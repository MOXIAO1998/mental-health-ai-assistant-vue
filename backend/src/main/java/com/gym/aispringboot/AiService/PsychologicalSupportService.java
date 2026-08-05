package com.gym.aispringboot.AiService;

import com.gym.aispringboot.DTO.command.ConsultationSessionCreateDTO;
import com.gym.aispringboot.DTO.response.ConsultationMessageResponseDTO;
import com.gym.aispringboot.entity.ConsultationSession;
import com.gym.aispringboot.service.ConsultationMessageService;
import com.gym.aispringboot.service.ConsultationSessionService;
import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.messages.AssistantMessage;
import org.springframework.ai.chat.messages.Message;
import org.springframework.ai.chat.messages.SystemMessage;
import org.springframework.ai.chat.messages.UserMessage;
import org.springframework.ai.chat.prompt.Prompt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Service;
import reactor.core.publisher.Flux;

import java.util.ArrayList;
import java.util.List;

@Service
public class PsychologicalSupportService {
    @Autowired
    @Qualifier("open-ai")
    private ChatClient chatClient;

    @Autowired
    private ChatMemory chatMemory;


    @Autowired
    private ConsultationMessageService consultationMessageService;

    @Autowired
    public ConsultationSessionService consultationSessionService;

    public StructOutput.StreamChatSession startSession(Long userId, ConsultationSessionCreateDTO createDTO) {
        // create a database session record
        ConsultationSession consultationSession = consultationSessionService.createSession(userId, createDTO);

        // store initial user message to the message table in a database
        consultationMessageService.saveUserMessage(consultationSession.getId(), createDTO.getInitialMessage(), null);

        // return data to controller
        // create session info
        String sessionId = "session_" + consultationSession.getId();
        return new StructOutput.StreamChatSession(sessionId, userId, createDTO.getInitialMessage(), System.currentTimeMillis(), System.currentTimeMillis() + 86400000L, // 24 hourse
                1, "ACTIVE");


    }


    public Flux<String> streamPsychologicalChat(String sessionId, String userMessage) {
        // create reactive stream
        return Flux.create(sink -> {
            // sink.next("data") publish data to stream
            // sink.complete()  finish stream
            // sink.error(exception)  publish error to stream
            Long dbSessionId = extractSessionId(sessionId);

            if (dbSessionId == null) {
                sink.error(new RuntimeException("session id format error"));
                return;
            }


            // if the message is initial
            boolean isInitialMessage = false;
            // check if it is an initial message. to avoid duplicate storage
            Integer messageCount = consultationMessageService.getMessageCountBySessionId(dbSessionId);
            if (messageCount == 1) {
                // get the last message
                ConsultationMessageResponseDTO lastMessage = consultationMessageService.getLastMessageBySessionId(dbSessionId);
                if (lastMessage != null && lastMessage.getSenderType() == 1 && userMessage.equals(lastMessage.getContent())) {
                    isInitialMessage = true;
                }
            }

            if (!isInitialMessage) {
                // store user message to the message table in a database
                consultationMessageService.saveUserMessage(dbSessionId, userMessage, null);
            }

            // streamed chat
            // construct system prompt
            // generate a chat memory management
            String conversationId = "conversation_" + sessionId;
            List<Message> userMessages = new ArrayList<>();
            userMessages.add(new UserMessage(userMessage));
            chatMemory.add(conversationId, userMessages);
            Prompt prompt = new Prompt(List.of(new SystemMessage(PromptManagement.PSYCHOLOGICAL_SUPPORT_SYSTEM_PROMPT)));


            // store Ai full response
            StringBuilder fullResponse = new StringBuilder();

            // user chatClient to send a message to OpenAI
            chatClient.prompt(prompt).user(userMessage).advisors(advisorSpec -> advisorSpec.param(ChatMemory.CONVERSATION_ID, conversationId)).stream().content().doOnNext(Fragment -> {
                fullResponse.append(Fragment);
                sink.next(Fragment);
            }).doOnComplete(() -> {
                String completeRes = fullResponse.toString();
                // store ai content to database
                consultationMessageService.saveAiMessage(dbSessionId, fullResponse.toString(), "openai");
                // add AU response to chatMemory
                List<Message> aiMessages = new ArrayList<>();
                aiMessages.add(new AssistantMessage(completeRes));
                chatMemory.add(conversationId, aiMessages);
                sink.complete();
            }).doOnError(error -> {
                sink.error(error);
            }).subscribe(); // subscribe and launch the stream

        });
    }

    // extract session id
    public Long extractSessionId(String sessionId) {
        if (sessionId != null && sessionId.startsWith("session_")) {
            String idStr = sessionId.substring("session_".length());

            return Long.parseLong(idStr);
        }


        return null;
    }


}
