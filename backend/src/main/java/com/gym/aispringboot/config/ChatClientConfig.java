package com.gym.aispringboot.config;

import org.springframework.ai.chat.client.ChatClient;
import org.springframework.ai.chat.client.advisor.MessageChatMemoryAdvisor;
import org.springframework.ai.chat.memory.ChatMemory;
import org.springframework.ai.chat.memory.MessageWindowChatMemory;
import org.springframework.ai.openai.OpenAiChatModel;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class ChatClientConfig {

    @Bean
    public ChatMemory chatMemory() {
        return MessageWindowChatMemory.builder().maxMessages(30). // 30 latest messages
                build();
    }


    @Bean("open-ai")
    public ChatClient openAiChatClient(OpenAiChatModel openAiChatModel) {
        return ChatClient.builder(openAiChatModel).
                defaultAdvisors(MessageChatMemoryAdvisor.builder(chatMemory()).build()).
                defaultSystem("Act as a professional psychological counselor, " +
                        "gentle and patient, good at listening, " +
                        "and capable of providing professional psychological support and advice " +
                        "based on the content of the conversation.").
                build();

    }
}
