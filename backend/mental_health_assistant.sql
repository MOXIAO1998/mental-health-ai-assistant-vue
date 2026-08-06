/*
 Navicat Premium Dump SQL

 Source Server         : mysql8.0
 Source Server Type    : MySQL
 Source Server Version : 80042 (8.0.42)
 Source Host           : localhost:3306
 Source Schema         : mental_health_assistant

 Target Server Type    : MySQL
 Target Server Version : 80042 (8.0.42)
 File Encoding         : 65001

 Date: 15/11/2025 11:15:33
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for ai_analysis_task
-- ----------------------------
DROP TABLE IF EXISTS `ai_analysis_task`;
CREATE TABLE `ai_analysis_task`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Task ID',
  `diary_id` bigint NOT NULL COMMENT 'Diary ID',
  `user_id` bigint NOT NULL COMMENT 'User ID',
  `status` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Task status: PENDING-Pending, PROCESSING-Processing, COMPLETED-Completed, FAILED-Failed',
  `task_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Task type: AUTO-Automatically triggered, MANUAL-Manually triggered, ADMIN-Administrator triggered, BATCH-Batch triggered',
  `priority` int NOT NULL DEFAULT 2 COMMENT 'Priority: 1-Low, 2-Normal, 3-High, 4-Urgent',
  `retry_count` int NOT NULL DEFAULT 0 COMMENT 'Retry count',
  `max_retry_count` int NOT NULL DEFAULT 3 COMMENT 'Maximum retry count',
  `error_message` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'Error message',
  `started_at` datetime NULL DEFAULT NULL COMMENT 'Processing start time',
  `completed_at` datetime NULL DEFAULT NULL COMMENT 'Processing completion time',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Update time',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_diary_id`(`diary_id` ASC) USING BTREE,
  INDEX `idx_user_id`(`user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_task_type`(`task_type` ASC) USING BTREE,
  INDEX `idx_priority`(`priority` ASC) USING BTREE,
  INDEX `idx_created_at`(`created_at` ASC) USING BTREE,
  INDEX `idx_status_priority`(`status` ASC, `priority` ASC) USING BTREE,
  INDEX `idx_status_created_at`(`status` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_task_type_created_at`(`task_type` ASC, `created_at` ASC) USING BTREE,
  INDEX `idx_retry_status`(`status` ASC, `retry_count` ASC, `max_retry_count` ASC) USING BTREE,
  CONSTRAINT `fk_ai_task_diary` FOREIGN KEY (`diary_id`) REFERENCES `emotion_diary` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `fk_ai_task_user` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 46 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'AI analysis task table' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of ai_analysis_task
-- ----------------------------
INSERT INTO `ai_analysis_task` VALUES (32, 8, 2, 'COMPLETED', 'AUTO', 2, 0, 3, NULL, '2025-09-14 09:42:34', '2025-09-14 09:42:44', '2025-09-14 09:42:34', '2025-09-14 09:42:44');
INSERT INTO `ai_analysis_task` VALUES (33, 8, 2, 'COMPLETED', 'AUTO', 2, 0, 3, NULL, '2025-09-14 14:04:32', '2025-09-14 14:04:37', '2025-09-14 14:04:32', '2025-09-14 14:04:37');
INSERT INTO `ai_analysis_task` VALUES (34, 5, 2, 'COMPLETED', 'ADMIN', 3, 0, 3, NULL, '2025-09-14 14:05:48', '2025-09-14 14:05:52', '2025-09-14 14:05:48', '2025-09-14 14:05:52');
INSERT INTO `ai_analysis_task` VALUES (35, 8, 2, 'COMPLETED', 'AUTO', 2, 0, 3, NULL, '2025-09-14 14:13:21', '2025-09-14 14:13:26', '2025-09-14 14:13:21', '2025-09-14 14:13:26');
INSERT INTO `ai_analysis_task` VALUES (36, 8, 2, 'COMPLETED', 'ADMIN', 3, 0, 3, NULL, '2025-09-14 14:14:21', '2025-09-14 14:14:45', '2025-09-14 14:14:21', '2025-09-14 14:14:45');
INSERT INTO `ai_analysis_task` VALUES (37, 26, 2, 'COMPLETED', 'AUTO', 2, 0, 3, NULL, '2025-11-10 13:00:34', '2025-11-10 13:00:34', '2025-11-10 13:00:34', '2025-11-10 13:00:34');
INSERT INTO `ai_analysis_task` VALUES (38, 26, 2, 'COMPLETED', 'ADMIN', 3, 0, 3, NULL, '2025-11-10 13:02:16', '2025-11-10 13:02:16', '2025-11-10 13:02:16', '2025-11-10 13:02:16');
INSERT INTO `ai_analysis_task` VALUES (39, 26, 2, 'COMPLETED', 'AUTO', 2, 0, 3, NULL, '2025-11-10 19:05:55', '2025-11-10 19:06:00', '2025-11-10 19:05:55', '2025-11-10 19:06:00');
INSERT INTO `ai_analysis_task` VALUES (40, 26, 2, 'COMPLETED', 'AUTO', 2, 0, 3, NULL, '2025-11-10 19:06:00', '2025-11-10 19:06:08', '2025-11-10 19:06:00', '2025-11-10 19:06:08');
INSERT INTO `ai_analysis_task` VALUES (41, 26, 2, 'COMPLETED', 'ADMIN', 3, 0, 3, NULL, '2025-11-10 19:08:20', '2025-11-10 19:08:25', '2025-11-10 19:08:20', '2025-11-10 19:08:25');
INSERT INTO `ai_analysis_task` VALUES (42, 28, 4, 'COMPLETED', 'AUTO', 2, 0, 3, NULL, '2025-11-11 09:34:41', '2025-11-11 09:34:49', '2025-11-11 09:34:41', '2025-11-11 09:34:49');
INSERT INTO `ai_analysis_task` VALUES (43, 27, 2, 'COMPLETED', 'AUTO', 2, 0, 3, NULL, '2025-11-11 10:08:14', '2025-11-11 10:08:34', '2025-11-11 10:08:14', '2025-11-11 10:08:34');
INSERT INTO `ai_analysis_task` VALUES (44, 27, 2, 'COMPLETED', 'AUTO', 2, 0, 3, NULL, '2025-11-11 10:10:28', '2025-11-11 10:10:35', '2025-11-11 10:10:28', '2025-11-11 10:10:35');
INSERT INTO `ai_analysis_task` VALUES (45, 27, 2, 'COMPLETED', 'AUTO', 2, 0, 3, NULL, '2025-11-11 10:12:13', '2025-11-11 10:12:18', '2025-11-11 10:12:13', '2025-11-11 10:12:18');

-- ----------------------------
-- Table structure for consultation_message
-- ----------------------------
DROP TABLE IF EXISTS `consultation_message`;
CREATE TABLE `consultation_message`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Message ID',
  `session_id` bigint NOT NULL COMMENT 'Session ID',
  `sender_type` tinyint NOT NULL COMMENT 'Sender type 1:User 2:AI assistant',
  `message_type` tinyint NULL DEFAULT 1 COMMENT 'Message type 1:Text',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Message content',
  `emotion_tag` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Emotion tag',
  `ai_model` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'AI model used',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_session_message`(`session_id` ASC, `created_at` ASC) USING BTREE,
  CONSTRAINT `consultation_message_ibfk_1` FOREIGN KEY (`session_id`) REFERENCES `consultation_session` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 111 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Consultation message table' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of consultation_message
-- ----------------------------
INSERT INTO `consultation_message` VALUES (98, 17, 1, 1, 'Hello, my name is Xiaoming', NULL, NULL, '2025-09-14 14:11:53');
INSERT INTO `consultation_message` VALUES (99, 17, 2, 1, 'Hello, Xiaoming! 😊 It is very nice to meet you~I am your mental health assistant. You can call me "Warmheart" or "Xiaonuan." How have you been lately? As a university student, do you have many things you would like to share? 💬\n\nYou can talk to me about anything, whether it is academic pressure, relationships, or uncertainty and confusion about the future...I am here and listening carefully✨', NULL, 'openai', '2025-09-14 14:11:58');
INSERT INTO `consultation_message` VALUES (100, 17, 1, 1, 'I was admitted to graduate school, but I feel very lost', NULL, NULL, '2025-09-14 14:12:09');
INSERT INTO `consultation_message` VALUES (101, 17, 2, 1, 'Congratulations on getting into graduate school, Xiaoming! 🎉 That is truly wonderful news to be proud of~But I completely understand how you feel when you say you are confused😊\n\nGraduate school is indeed very different from undergraduate study. Could you tell me more about where your uncertainty comes from? ✨ For example:\n1️⃣ Are you worried that the academic pressure will be too high?\n2️⃣ Are you unsure about your research direction?\n3️⃣ Or are you confused about your future career plan?\n\nYou know, this kind of "post-admission uncertainty" is actually very common~It is a normal reaction when you stand at a new starting line and see so many possibilities ahead🌟\n\nWould you like us to sort it out together? Take your time. I am listening💛', NULL, 'openai', '2025-09-14 14:12:19');
INSERT INTO `consultation_message` VALUES (102, 17, 1, 1, 'Could you give me some advice about graduate school?', NULL, NULL, '2025-09-14 14:12:29');
INSERT INTO `consultation_message` VALUES (103, 17, 2, 1, 'Of course, Xiaoming! 🎓 As you prepare to begin graduate school, these suggestions may help you~✨\n\n🔍 **Academic Adjustment**:\n1️⃣ Contact your advisor proactively: Before the semester begins, you can email your advisor to discuss research directions and your study plan\n2️⃣ Develop good literature-management habits: Try Zotero/EndNote and build your reference library from day one\n3️⃣ Take academic notes every week: Recording ideas is much easier than trying to recall them later\n\n💡 **Mindset Tips**:\n- Allow yourself to warm up gradually during the first semester⏳ Many people need 3-6 months to adjust to the pace\n- Break large goals into quarterly/monthly goals to increase your sense of accomplishment↑\n- Your labmates are your best teammates, so share questions and resources with them\n\n👩💻 **Useful Tools**:\n✓ Pomodoro app (25 minutes of focus + 5 minutes of rest)\n✓ Mark important milestones on an academic calendar\n✓ Back up your research data regularly! (A lesson learned the hard way)\n\nXiaoming, I noticed that you mentioned feeling lost earlier, and I especially want to tell you that uncertainty during graduate school is completely normal~🤗 You could:\n- Attend more lab meetings after the semester starts in September\n- Audit 1-2 courses in related fields\n- Invite senior students for coffee and ask about their experience\n\nRemember, graduate school is a marathon, not a sprint🏃. Finding your own pace is what matters most! Which area would you most like to prepare for first? 💭', NULL, 'openai', '2025-09-14 14:12:47');
INSERT INTO `consultation_message` VALUES (104, 18, 1, 1, 'I have a slight headache', NULL, NULL, '2025-11-10 12:57:39');
INSERT INTO `consultation_message` VALUES (105, 19, 1, 1, 'Headache', NULL, NULL, '2025-11-10 13:07:18');
INSERT INTO `consultation_message` VALUES (106, 19, 2, 1, 'Hearing that you have a headache, I can tell that you must be feeling uncomfortable right now. 😔 University life can easily cause headaches because of academic pressure, irregular sleep schedules, and other factors. Shall we take a few deep breaths first? 🌬️\n\nYou can try:\n1. Find a quiet place, close your eyes, and rest for 5 minutes\n2. Gently massage your temples\n3. Drink some warm water\n4. If you have been looking at a computer for a long time, try some eye exercises\n\nRemember, your health is the most important thing~If the discomfort continues, consider visiting the campus clinic. Would you like to talk with me about what may be causing the headache?', NULL, 'openai', '2025-11-10 13:07:25');
INSERT INTO `consultation_message` VALUES (107, 20, 1, 1, 'Hello, I am feeling a little down', NULL, NULL, '2025-11-10 19:05:17');
INSERT INTO `consultation_message` VALUES (108, 20, 2, 1, 'Dear student, I can tell that you are not feeling very well emotionally right now. 🥺 This low mood must be uncomfortable. Would you like to tell me what is making you unhappy? Whether it is academic pressure, relationships, or another concern, I will listen carefully.\n\nRemember, everyone feels down sometimes, and that is normal. Being willing to talk about it is already a very good first step. 💪 \n\n(It is also okay if you do not want to discuss the specific reason yet. We can first talk about something else that may help you feel a little better.)', NULL, 'openai', '2025-11-10 19:05:21');
INSERT INTO `consultation_message` VALUES (109, 21, 1, 1, 'I want to travel', NULL, NULL, '2025-11-12 08:34:20');
INSERT INTO `consultation_message` VALUES (110, 21, 2, 1, 'Hearing that you want to travel, I can sense your desire for new experiences and relaxation~✨  \n\nTravel can indeed be a great way to recharge! Is there a particular reason you suddenly want to leave? For example, have you been under a lot of pressure recently, or do you simply want a change of environment? 🧐  \n\nIf you want to improve your mood, even walking around the area near your school or exploring unfamiliar shops can bring a sense of freshness. Of course, if circumstances allow, planning your itinerary and budget for a farther destination can also be wonderful! Would you like to talk about where you want to go? 😊  \n\nP.S. A spontaneous trip sounds romantic, but remember to check the weather and transportation information in advance~', NULL, 'openai', '2025-11-12 08:34:27');

-- ----------------------------
-- Table structure for consultation_session
-- ----------------------------
DROP TABLE IF EXISTS `consultation_session`;
CREATE TABLE `consultation_session`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Session ID',
  `user_id` bigint NOT NULL COMMENT 'User ID',
  `session_title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Session title',
  `started_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `last_emotion_analysis` json NULL COMMENT 'Most recent emotion analysis result (JSON format)',
  `last_emotion_updated_at` datetime NULL DEFAULT NULL COMMENT 'Most recent emotion analysis update time',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_user_session`(`user_id` ASC, `started_at` ASC) USING BTREE,
  INDEX `idx_last_emotion_updated_at`(`last_emotion_updated_at` ASC) USING BTREE,
  CONSTRAINT `consultation_session_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 22 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Consultation session table' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of consultation_session
-- ----------------------------
INSERT INTO `consultation_session` VALUES (17, 2, 'Xiaonuan Assistant - 9/14/2025, 2:11:52 PM', '2025-09-14 14:11:53', '{\"icon\": \"🤔\", \"label\": \"Inquisitive\", \"keywords\": [\"Advice\", \"Learning\", \"Preparation\", \"Planning\", \"Consultation\"], \"riskLevel\": 0, \"timestamp\": 1719216000000, \"isNegative\": false, \"suggestion\": \"I am glad to provide advice about graduate school\", \"emotionScore\": 45, \"primaryEmotion\": \"Thoughtful\", \"riskDescription\": \"Emotionally stable\", \"improvementSuggestions\": [\"List specific questions\", \"Ask senior students about their experience\", \"Plan a research direction\", \"Create a study plan\"]}', '2025-09-14 14:12:35');
INSERT INTO `consultation_session` VALUES (18, 2, 'Xiaonuan Assistant - 2025/11/10 12:57:39', '2025-11-10 12:57:39', '{\"icon\": \"😐\", \"label\": \"Calm\", \"keywords\": [], \"riskLevel\": 0, \"timestamp\": 1762750675283, \"isNegative\": false, \"suggestion\": \"Your emotional state is stable, so take things one step at a time\", \"emotionScore\": 50, \"primaryEmotion\": \"Neutral\", \"riskDescription\": \"Your current emotional state is stable and does not require special attention\", \"improvementSuggestions\": [\"Maintain a regular schedule\", \"Exercise appropriately\", \"Talk with friends\"]}', '2025-11-10 12:57:55');
INSERT INTO `consultation_session` VALUES (19, 2, 'Xiaonuan Assistant - 2025/11/10 13:07:18', '2025-11-10 13:07:18', '{\"icon\": \"😔\", \"label\": \"Troubled\", \"keywords\": [\"Headache\", \"Discomfort\", \"Concern\"], \"riskLevel\": 1, \"timestamp\": 1711430400000, \"isNegative\": true, \"suggestion\": \"When you have a headache, try resting in a quiet place for a while\", \"emotionScore\": 45, \"primaryEmotion\": \"Troubled\", \"riskDescription\": \"Needs attention\", \"improvementSuggestions\": [\"Drink a cup of warm water\", \"Close your eyes and rest\", \"Gently massage your temples\"]}', '2025-11-10 13:07:25');
INSERT INTO `consultation_session` VALUES (20, 2, 'Xiaonuan Assistant - 2025/11/10 19:05:16', '2025-11-10 19:05:16', '{\"icon\": \"😢\", \"label\": \"Down\", \"keywords\": [\"Mood\", \"Unwell\", \"Down\"], \"riskLevel\": 1, \"timestamp\": 1711861280000, \"isNegative\": true, \"suggestion\": \"Sending you a hug. When you are unhappy, try talking with a friend\", \"emotionScore\": 45, \"primaryEmotion\": \"Sadness\", \"riskDescription\": \"Needs attention\", \"improvementSuggestions\": [\"Take deep breaths and relax\", \"Listen to a favorite song\", \"Write in a mood journal\"]}', '2025-11-10 19:05:23');
INSERT INTO `consultation_session` VALUES (21, 2, 'Xiaonuan Assistant - 2025/11/12 08:34:20', '2025-11-12 08:34:20', '{\"icon\": \"😊\", \"label\": \"Happy\", \"keywords\": [\"Travel\", \"Anticipation\", \"Relaxation\"], \"riskLevel\": 0, \"timestamp\": 1713866220000, \"isNegative\": false, \"suggestion\": \"Have a wonderful trip and enjoy the experience\", \"emotionScore\": 65, \"primaryEmotion\": \"Happy\", \"riskDescription\": \"Emotionally stable\", \"improvementSuggestions\": [\"Plan the travel route\", \"Prepare a travel checklist\", \"Share travel ideas\"]}', '2025-11-12 08:34:26');

-- ----------------------------
-- Table structure for emotion_diary
-- ----------------------------
DROP TABLE IF EXISTS `emotion_diary`;
CREATE TABLE `emotion_diary`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Diary ID',
  `user_id` bigint NOT NULL COMMENT 'User ID',
  `diary_date` date NOT NULL COMMENT 'Diary date',
  `mood_score` tinyint NOT NULL COMMENT 'Mood score (1-10)',
  `dominant_emotion` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Dominant emotion',
  `emotion_triggers` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'Emotion triggers',
  `diary_content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'Diary content',
  `sleep_quality` tinyint NULL DEFAULT NULL COMMENT 'Sleep quality (1-5)',
  `stress_level` tinyint NULL DEFAULT NULL COMMENT 'Stress level (1-5)',
  `ai_emotion_analysis` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'AI emotion analysis result (JSON format)',
  `ai_analysis_updated_at` datetime NULL DEFAULT NULL COMMENT 'AI analysis update time',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_date_unique`(`user_id` ASC, `diary_date` ASC) USING BTREE,
  INDEX `idx_user_diary`(`user_id` ASC, `diary_date` ASC) USING BTREE,
  INDEX `idx_ai_analysis_time`(`ai_analysis_updated_at` ASC) USING BTREE,
  CONSTRAINT `emotion_diary_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 29 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Emotion diary table' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of emotion_diary
-- ----------------------------
INSERT INTO `emotion_diary` VALUES (2, 2, '2025-09-08', 7, 'Pleasant', 'Completed an important project', 'Today I successfully completed an important project and felt a strong sense of accomplishment. The teamwork also went smoothly, and everyone cooperated well.', 4, 2, NULL, NULL, '2025-09-08 09:41:02', '2025-09-08 09:41:02');
INSERT INTO `emotion_diary` VALUES (3, 2, '2025-09-09', 6, 'Calm', 'Daily study', 'Today was a fairly ordinary day. I completed my study tasks as planned. Nothing special happened, and I felt relatively calm.', 4, 2, NULL, NULL, '2025-09-09 09:41:02', '2025-09-09 09:41:02');
INSERT INTO `emotion_diary` VALUES (4, 2, '2025-09-10', 8, 'Excited', 'Received good news', 'I received the good news I had been waiting for! I felt especially happy and could not resist sharing it with the friends around me.', 5, 1, NULL, NULL, '2025-09-10 09:41:02', '2025-09-10 09:41:02');
INSERT INTO `emotion_diary` VALUES (5, 2, '2025-09-11', 4, 'Anxious', 'Exam pressure', 'I have an important exam tomorrow. I have not reviewed enough and feel very anxious. I am worried that I will not do well.', 3, 4, '{\"primaryEmotion\":\"Anxious\",\"emotionScore\":40,\"isNegative\":true,\"riskLevel\":1,\"keywords\":[\"Exam\",\"Pressure\",\"Anxiety\",\"Review\"],\"suggestion\":\"A moderate amount of pressure can be turned into motivation\",\"icon\":\"😰\",\"label\":\"Anxious\",\"riskDescription\":\"Needs attention\",\"improvementSuggestions\":[\"Take deep breaths and relax\",\"Complete one final focused review\",\"Get enough sleep\"],\"timestamp\":1716192000000}', '2025-09-14 14:05:52', '2025-09-11 09:41:02', '2025-09-14 14:05:51');
INSERT INTO `emotion_diary` VALUES (6, 2, '2025-09-12', 6, 'Relaxed', 'Exam finished', 'The exam is finally over. Although I do not know the result, at least the pressure has been released. I can get some proper rest now.', 4, 2, NULL, NULL, '2025-09-12 09:41:02', '2025-09-12 09:41:02');
INSERT INTO `emotion_diary` VALUES (7, 2, '2025-09-13', 5, 'Tired', 'Busy at work', 'Work was especially busy today, and I spent the whole day handling different tasks. I feel physically and mentally tired and need a good rest.', 3, 3, NULL, NULL, '2025-09-13 09:41:02', '2025-09-13 09:41:02');
INSERT INTO `emotion_diary` VALUES (8, 2, '2025-09-14', 3, 'Anxious', 'Conflict with a friend', 'I had a conflict with a friend and feel very sad', 2, 4, '{\"primaryEmotion\":\"Anxious\",\"emotionScore\":75,\"isNegative\":true,\"riskLevel\":2,\"keywords\":[\"Friend\",\"Conflict\",\"Anxiety\",\"Pressure\",\"Sleep\"],\"suggestion\":\"The conflict with your friend is making you anxious. Try to calm down and communicate\",\"icon\":\"😰\",\"label\":\"Anxious\",\"riskDescription\":\"Psychological support is needed\",\"improvementSuggestions\":[\"Take deep breaths and relax\",\"Communicate honestly with your friend\",\"Improve your sleep environment\",\"Exercise moderately to relieve stress\"],\"timestamp\":1719216000000}', '2025-09-14 14:14:45', '2025-09-14 09:41:02', '2025-09-14 14:14:44');
INSERT INTO `emotion_diary` VALUES (14, 4, '2025-09-08', 5, 'Nervous', 'Adapting to a new environment', 'I just arrived in a new environment, and everything feels unfamiliar. I need time to adapt to the new pace of life.', 3, 3, NULL, NULL, '2025-09-08 09:41:02', '2025-09-08 09:41:02');
INSERT INTO `emotion_diary` VALUES (15, 4, '2025-09-09', 6, 'Curious', 'Exploring new things', 'I started exploring the surrounding area and discovered many interesting places. I feel curious about the future.', 4, 2, NULL, NULL, '2025-09-09 09:41:02', '2025-09-09 09:41:02');
INSERT INTO `emotion_diary` VALUES (16, 4, '2025-09-10', 8, 'Excited', 'Meeting new friends', 'Today I met several interesting new friends, and we had a great conversation. Life is beginning to feel richer and more colorful.', 5, 1, NULL, NULL, '2025-09-10 09:41:02', '2025-09-10 09:41:02');
INSERT INTO `emotion_diary` VALUES (17, 4, '2025-09-11', 4, 'Lonely', 'Missing home', 'I suddenly miss my hometown and family and feel a little lonely. Although the new environment is good, I still feel homesick.', 3, 3, NULL, NULL, '2025-09-11 09:41:02', '2025-09-11 09:41:02');
INSERT INTO `emotion_diary` VALUES (18, 4, '2025-09-12', 7, 'Fulfilled', 'A busy day', 'Today was very fulfilling, and I completed many tasks. I feel that I am gradually adapting to my new life.', 4, 2, NULL, NULL, '2025-09-12 09:41:02', '2025-09-12 09:41:02');
INSERT INTO `emotion_diary` VALUES (19, 4, '2025-09-13', 3, 'Frustrated', 'Encountered difficulties', 'I encountered some difficulties and felt a little discouraged. However, I believe I can overcome them through hard work.', 2, 4, NULL, NULL, '2025-09-13 09:41:02', '2025-09-13 09:41:02');
INSERT INTO `emotion_diary` VALUES (20, 4, '2025-09-14', 6, 'Determined', 'Making a plan', 'I created a detailed plan for myself, and my goals now feel clearer. Having direction gives me motivation.', 4, 2, NULL, NULL, '2025-09-14 09:41:02', '2025-09-14 09:41:02');
INSERT INTO `emotion_diary` VALUES (26, 2, '2025-11-10', 10, 'Happy', 'Happy', 'Pleasant', 5, 1, '{\"primaryEmotion\":\"Happy\",\"emotionScore\":100,\"isNegative\":false,\"riskLevel\":0,\"keywords\":[\"Pleasant\",\"Happy\",\"Satisfied\"],\"suggestion\":\"Keep this wonderful mood and enjoy the happiness of the present moment\",\"icon\":\"😊\",\"label\":\"Pleasant\",\"riskDescription\":\"Emotionally stable\",\"improvementSuggestions\":[\"Share happy moments\",\"Record your positive mood\",\"Do something you enjoy\"],\"timestamp\":1711861280000}', '2025-11-10 19:08:25', '2025-11-10 13:00:26', '2025-11-10 19:08:24');
INSERT INTO `emotion_diary` VALUES (27, 2, '2025-11-11', 10, 'Happy', 'Happy', 'Happy', 5, 1, '{\"primaryEmotion\":\"Happy\",\"emotionScore\":100,\"isNegative\":false,\"riskLevel\":0,\"keywords\":[\"Happy\",\"Excited\",\"Satisfied\"],\"suggestion\":\"Keep enjoying this wonderful mood\",\"icon\":\"😄\",\"label\":\"Happy\",\"riskDescription\":\"Excellent emotional state\",\"improvementSuggestions\":[\"Share your happiness\",\"Record beautiful moments\",\"Do something fun\"],\"timestamp\":1715000000000}', '2025-11-11 10:12:18', '2025-11-11 08:44:08', '2025-11-11 10:12:17');
INSERT INTO `emotion_diary` VALUES (28, 4, '2025-11-11', 6, 'Calm', 'Happy', 'Happy', 4, 2, '{\"primaryEmotion\":\"Happy\",\"emotionScore\":60,\"isNegative\":false,\"riskLevel\":0,\"keywords\":[\"Happy\",\"Calm\",\"Satisfied\"],\"suggestion\":\"Keep enjoying this happy mood\",\"icon\":\"😊\",\"label\":\"Happy\",\"riskDescription\":\"Emotionally stable\",\"improvementSuggestions\":[\"Record beautiful moments\",\"Share happiness with friends\",\"Do something you enjoy\"],\"timestamp\":1715000000000}', '2025-11-11 09:34:49', '2025-11-11 09:34:07', '2025-11-11 09:34:48');

-- ----------------------------
-- Table structure for knowledge_article
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_article`;
CREATE TABLE `knowledge_article`  (
  `id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Article ID (UUID)',
  `category_id` bigint NOT NULL COMMENT 'Category ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Article title',
  `summary` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'Article summary',
  `content` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Article content',
  `cover_image` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Cover image',
  `tags` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Tags',
  `author_id` bigint NULL DEFAULT NULL COMMENT 'Author ID',
  `read_count` int NULL DEFAULT 0 COMMENT 'Read count',
  `status` tinyint NULL DEFAULT 1 COMMENT 'Status 1:Published',
  `published_at` datetime NULL DEFAULT NULL COMMENT 'Publication time',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `author_id`(`author_id` ASC) USING BTREE,
  INDEX `idx_category_article`(`category_id` ASC, `published_at` ASC) USING BTREE,
  INDEX `idx_title`(`title` ASC) USING BTREE,
  CONSTRAINT `knowledge_article_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `knowledge_category` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `knowledge_article_ibfk_2` FOREIGN KEY (`author_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Knowledge article table' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of knowledge_article
-- ----------------------------
INSERT INTO `knowledge_article` VALUES ('550e8400-e29b-41d4-a716-446655440001', 1, 'How to Recognize and Manage Anxiety', 'Anxiety is a common emotional response in modern life. Learning to recognize and manage anxiety is essential for mental health.', '<p>Anxiety is a normal emotional response, but excessive anxiety may affect our daily lives. This article explains how to recognize the symptoms of anxiety and introduces several effective management methods.</p><h3>Recognizing the Symptoms of Anxiety</h3><ul><li>Rapid heartbeat and sweating</li><li>Shortness of breath</li><li>Confused thinking</li><li>Difficulty concentrating</li></ul><h3>Methods for Managing Anxiety</h3><ol><li>Deep-breathing exercises</li><li>Mindfulness meditation</li><li>Moderate exercise</li><li>Seeking professional help</li></ol>', '', 'Anxiety,Emotion Management,Mental Health', 1, 15, 1, '2025-09-01 10:00:00', '2025-09-01 10:00:00', '2025-09-01 10:00:00');
INSERT INTO `knowledge_article` VALUES ('550e8400-e29b-41d4-a716-446655440002', 2, 'Five Effective Strategies for Emotional Regulation', 'Master emotional regulation skills to make life more balanced and harmonious.', '<p>Emotional regulation is an important part of mental health. The following are five scientifically validated emotional regulation strategies:</p><h3>1. Cognitive Restructuring</h3><p>Learn to view problems from different perspectives and challenge negative thinking patterns.</p><h3>2. Emotion Labeling</h3><p>Accurately recognize and name your emotional state.</p><h3>3. Progressive Muscle Relaxation</h3><p>Relieve emotional tension through physical relaxation.</p><h3>4. Expressive Writing</h3><p>Use writing to process complex emotional experiences.</p><h3>5. Social Support</h3><p>Seek understanding and support from friends and family.</p>', '', 'Emotional Regulation,Psychological Skills,Self-Management', 1, 23, 1, '2025-09-02 14:30:00', '2025-09-02 14:30:00', '2025-09-02 14:30:00');
INSERT INTO `knowledge_article` VALUES ('550e8400-e29b-41d4-a716-446655440003', 3, 'Workplace Stress Management Guide', 'In a fast-paced work environment, learning to manage stress effectively is a key part of professional success.', '<p>Workplace stress is an unavoidable challenge in modern working life. This guide will help you build an effective stress-management system.</p><h3>Identifying Sources of Stress</h3><ul><li>Excessive workload</li><li>Strained interpersonal relationships</li><li>Career-development anxiety</li><li>Difficulty balancing work and life</li></ul><h3>Stress-Management Strategies</h3><ol><li>Time-management techniques</li><li>Set reasonable goals</li><li>Build a support network</li><li>Develop hobbies and interests</li><li>Rest and relax regularly</li></ol><h3>Long-Term Stress Prevention</h3><p>Build healthy work habits and a healthy lifestyle to prevent stress from accumulating.</p>', '', 'Workplace Stress,Time Management,Work-Life Balance', 1, 31, 1, '2025-09-03 09:15:00', '2025-09-03 09:15:00', '2025-09-03 09:15:00');
INSERT INTO `knowledge_article` VALUES ('550e8400-e29b-41d4-a716-446655440004', 4, 'Building Healthy Interpersonal Relationships', 'Good interpersonal relationships are the foundation of mental health and a happy life.', '<p>The quality of our interpersonal relationships directly affects our mental health and life satisfaction. This article explores how to build and maintain healthy relationships.</p><h3>Characteristics of Healthy Relationships</h3><ul><li>Mutual respect and trust</li><li>Effective communication</li><li>Emotional support</li><li>Clear personal boundaries</li></ul><h3>Communication Skills</h3><ol><li>Active listening</li><li>Expressing genuine feelings</li><li>Nonviolent communication</li><li>Conflict resolution</li></ol><h3>Ways to Maintain Relationships</h3><p>Stay in touch regularly, express gratitude, grow together, and address disagreements.</p>', '', 'Interpersonal Relationships,Communication Skills,Social Skills', 1, 18, 1, '2025-09-04 16:20:00', '2025-09-04 16:20:00', '2025-09-04 16:20:00');
INSERT INTO `knowledge_article` VALUES ('550e8400-e29b-41d4-a716-446655440005', 1, 'Sleep Quality and Mental Health', 'High-quality sleep is an important foundation for maintaining mental health.', '<p>Sleep quality is closely related to mental health. Adequate sleep not only restores physical function but also has an important effect on emotional regulation and cognitive function.</p><h3>Effects of Sleep on Mental Health</h3><ul><li>Emotional stability</li><li>Ability to cope with stress</li><li>Memory and learning ability</li><li>Concentration</li></ul><h3>Ways to Improve Sleep Quality</h3><ol><li>Maintain a regular schedule</li><li>Create a healthy sleep environment</li><li>Use relaxing bedtime activities</li><li>Avoid stimulants</li><li>Exercise moderately</li></ol>', '', 'Sleep Health,Mental Health,Lifestyle Habits', 1, 27, 1, '2025-09-05 11:45:00', '2025-09-05 11:45:00', '2025-09-05 11:45:00');
INSERT INTO `knowledge_article` VALUES ('550e8400-e29b-41d4-a716-446655440006', 2, 'A Beginner Guide to Mindfulness Practice', 'Mindfulness practice is an effective method recommended by modern psychology for reducing stress and regulating emotions.', '<p>Mindfulness is a practice of focusing on present experience that can help us manage emotions and stress more effectively.</p><h3>What Is Mindfulness?</h3><p>Mindfulness is the ability to pay conscious, nonjudgmental attention to the present moment.</p><h3>Benefits of Mindfulness</h3><ul><li>Reduce anxiety and depression</li><li>Improve concentration</li><li>Improve emotional regulation</li><li>Increase self-awareness</li></ul><h3>Basic Mindfulness Practices</h3><ol><li>Breath observation</li><li>Body scan</li><li>Walking meditation</li><li>Everyday mindfulness</li></ol><h3>Practice Recommendations</h3><p>Start with 5-10 minutes each day and gradually increase the practice time.</p>', '', 'Mindfulness,Meditation,Stress Relief,Concentration', 1, 42, 1, '2025-09-06 13:10:00', '2025-09-06 13:10:00', '2025-09-06 13:10:00');
INSERT INTO `knowledge_article` VALUES ('550e8400-e29b-41d4-a716-446655440007', 3, 'Strategies for Coping with Student Psychological Stress', 'Help students recognize and cope with various forms of psychological stress in their academic and daily lives.', '<p>Students face multiple sources of pressure involving academics, relationships, and future planning. Mastering effective coping strategies is essential for student mental health.</p><h3>Common Sources of Stress</h3><ul><li>Academic-performance pressure</li><li>Peer relationships</li><li>Family expectations</li><li>Anxiety about future planning</li></ul><h3>Coping Strategies</h3><ol><li>Plan study time reasonably</li><li>Develop hobbies and interests</li><li>Build a support network</li><li>Learn relaxation techniques</li><li>Seek professional help</li></ol><h3>Preventive Measures</h3><p>Develop healthy study habits and a healthy lifestyle.</p>', '', 'Student Mental Health,Academic Stress,Adolescent Mental Health', 1, 35, 1, '2025-09-07 08:30:00', '2025-09-07 08:30:00', '2025-11-10 19:07:53');

-- ----------------------------
-- Table structure for knowledge_category
-- ----------------------------
DROP TABLE IF EXISTS `knowledge_category`;
CREATE TABLE `knowledge_category`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Category ID',
  `parent_id` bigint NULL DEFAULT 0 COMMENT 'Parent category ID',
  `category_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Category name',
  `category_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Category code',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL COMMENT 'Category description',
  `sort_order` int NULL DEFAULT 0 COMMENT 'Sort order',
  `status` tinyint NULL DEFAULT 1 COMMENT 'Status 0:Disabled 1:Enabled',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `category_code`(`category_code` ASC) USING BTREE,
  INDEX `idx_parent_id`(`parent_id` ASC) USING BTREE,
  INDEX `idx_sort_order`(`sort_order` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 12 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'Knowledge article category table' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of knowledge_category
-- ----------------------------
INSERT INTO `knowledge_category` VALUES (1, 0, 'Mental Health Basics', NULL, 'Basic mental health knowledge and concepts.', 30, 1, '2025-09-04 12:50:03', '2025-09-13 11:48:16');
INSERT INTO `knowledge_category` VALUES (2, 0, 'Emotion Management', NULL, 'Emotion recognition, regulation, and management techniques', 40, 1, '2025-09-04 12:50:03', '2025-09-13 11:48:16');
INSERT INTO `knowledge_category` VALUES (3, 0, 'Stress Relief', NULL, 'Analysis of stress sources and stress-relief methods', 20, 1, '2025-09-04 12:50:03', '2025-09-13 11:48:16');
INSERT INTO `knowledge_category` VALUES (4, 0, 'Interpersonal Relationships', NULL, 'Interpersonal communication and relationship management', 10, 1, '2025-09-04 12:50:03', '2025-09-13 11:48:16');

-- ----------------------------
-- Table structure for sys_file_info
-- ----------------------------
DROP TABLE IF EXISTS `sys_file_info`;
CREATE TABLE `sys_file_info`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'File ID, auto-incrementing primary key',
  `original_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Original file name (the file name when uploaded by the user)',
  `file_path` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'File access path (server storage path)',
  `file_size` bigint NOT NULL DEFAULT 0 COMMENT 'File size in bytes',
  `file_type` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'File type (IMG/PDF/TXT/DOC/XLS, etc.)',
  `business_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Business type (used to distinguish file purposes, such as avatar/document/attachment)',
  `business_id` char(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Business object ID (the primary key of the associated business data)',
  `business_field` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Business field name (the corresponding field name in the business table)',
  `upload_user_id` bigint NULL DEFAULT NULL COMMENT 'Uploading user ID (records who uploaded the file)',
  `is_temp` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Whether the file is temporary (0:No 1:Yes)',
  `status` tinyint(1) NOT NULL DEFAULT 1 COMMENT 'Status (0:Deleted 1:Normal)',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Creation time',
  `expire_time` datetime NULL DEFAULT NULL COMMENT 'Expiration time (valid only for temporary files)',
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_business`(`business_type` ASC, `business_id` ASC) USING BTREE,
  INDEX `idx_upload_user`(`upload_user_id` ASC) USING BTREE,
  INDEX `idx_status`(`status` ASC) USING BTREE,
  INDEX `idx_temp_expire`(`is_temp` ASC, `expire_time` ASC) USING BTREE,
  INDEX `idx_create_time`(`create_time` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 57 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'System file information table' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of sys_file_info
-- ----------------------------
INSERT INTO `sys_file_info` VALUES (46, '7487e74da9ec1ee07b5064348942b2ca.png', '/files/bussiness/article/1756963989972.png', 178205, 'IMG', 'ARTICLE', 'b51ecba7-db3c-4a30-84ab-3a19e1e8264b', 'cover', 1, 0, 1, '2025-09-04 13:33:10', NULL);
INSERT INTO `sys_file_info` VALUES (47, '7487e74da9ec1ee07b5064348942b2ca.png', '/files/bussiness/article/1756964062385.png', 178205, 'IMG', 'ARTICLE', 'null', 'cover', 1, 0, 1, '2025-09-04 13:34:22', NULL);
INSERT INTO `sys_file_info` VALUES (48, '7487e74da9ec1ee07b5064348942b2ca.png', '/files/bussiness/article/1756964101109.png', 178205, 'IMG', 'ARTICLE', 'e26ad80e-87b2-490f-87c3-2d5f981ba7bf', 'cover', 1, 0, 1, '2025-09-04 13:35:01', NULL);
INSERT INTO `sys_file_info` VALUES (49, '7487e74da9ec1ee07b5064348942b2ca.png', '/files/bussiness/article/1756964116665.png', 178205, 'IMG', 'ARTICLE', '8d79085d-4686-4af7-813d-4f97c936ff3e', 'cover', 1, 0, 1, '2025-09-04 13:35:17', NULL);
INSERT INTO `sys_file_info` VALUES (50, 'image323232s.jpg', '/files/temp/1757670438125.jpg', 7727, 'IMG', 'USER_AVATAR', '1', 'avatar', 1, 0, 0, '2025-09-12 17:47:18', '2025-09-13 17:47:18');
INSERT INTO `sys_file_info` VALUES (51, 'Untitled.jpg', '/files/temp/1757670832161.jpg', 7393, 'IMG', 'USER_AVATAR', '1', 'avatar', 1, 0, 0, '2025-09-12 17:53:52', '2025-09-13 17:53:52');
INSERT INTO `sys_file_info` VALUES (52, 'ima9897ges.jpg', '/files/temp/1757670856780.jpg', 4977, 'IMG', 'USER_AVATAR', '1', 'avatar', 1, 0, 0, '2025-09-12 17:54:17', '2025-09-13 17:54:17');
INSERT INTO `sys_file_info` VALUES (53, 'image323232s.jpg', '/files/bussiness/user_avatar/1757687320361.jpg', 7727, 'IMG', 'USER_AVATAR', '1', 'avatar', 1, 0, 1, '2025-09-12 22:28:40', NULL);
INSERT INTO `sys_file_info` VALUES (54, '0a157ddd8a7070c5240fb3ad23a5fc38.jpeg', '/files/bussiness/article/1757687894684.jpeg', 135321, 'IMG', 'ARTICLE', '550e8400-e29b-41d4-a716-446655440008', 'cover', 1, 0, 1, '2025-09-12 22:38:15', NULL);
INSERT INTO `sys_file_info` VALUES (55, 'Unti555tled.jpg', '/files/bussiness/user_avatar/1757816752928.jpg', 6389, 'IMG', 'USER_AVATAR', '2', 'avatar', 2, 0, 1, '2025-09-14 10:25:53', NULL);
INSERT INTO `sys_file_info` VALUES (56, '8b3e121c9f4bb2cfc3603a6ad576da8f.jpg', '/files/bussiness/article/1762908097203.jpg', 75721, 'IMG', 'ARTICLE', '550e8400-e29b-41d4-a716-446655440007', 'cover', 1, 0, 1, '2025-11-12 08:41:37', NULL);

-- ----------------------------
-- Table structure for user
-- ----------------------------
DROP TABLE IF EXISTS `user`;
CREATE TABLE `user`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'User ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Username',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Email',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Phone number',
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Password',
  `nickname` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Nickname',
  `avatar` varchar(500) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NULL DEFAULT NULL COMMENT 'Avatar URL',
  `gender` tinyint NULL DEFAULT NULL COMMENT 'Gender 0:Unknown 1:Male 2:Female',
  `birthday` date NULL DEFAULT NULL COMMENT 'Birthday',
  `user_type` tinyint NULL DEFAULT 1 COMMENT 'User type 1:Regular user 2:Administrator',
  `status` tinyint NULL DEFAULT 1 COMMENT 'Status 0:Disabled 1:Normal',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `username`(`username` ASC) USING BTREE,
  UNIQUE INDEX `email`(`email` ASC) USING BTREE,
  UNIQUE INDEX `phone`(`phone` ASC) USING BTREE,
  INDEX `idx_username`(`username` ASC) USING BTREE,
  INDEX `idx_user_type`(`user_type` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'User table' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user
-- ----------------------------
INSERT INTO `user` VALUES (1, 'admin', 'admin@example.com', '13123456789', '$2a$10$qUjCfQLqf9qVt1w1LDoaj.f5TUzBYcXh3FNNA0BhoQ54Vv2cSUt7K', 'System Administrator', '/files/bussiness/user_avatar/1757687320361.jpg', 1, '2019-09-02', 2, 1, '2025-08-30 12:00:01', '2025-09-12 22:28:42');
INSERT INTO `user` VALUES (2, 'test', '15165@qq.com', '13132584165', '$2a$10$qUjCfQLqf9qVt1w1LDoaj.f5TUzBYcXh3FNNA0BhoQ54Vv2cSUt7K', 'tyest', '/files/bussiness/user_avatar/1757816752928.jpg', 1, '2002-08-01', 1, 1, '2025-08-30 17:22:24', '2025-09-14 10:25:54');
INSERT INTO `user` VALUES (4, 'ces', '111111111111@qq.com', '13123456654', '$2a$10$Sy22CXQJe5OAS.Xvmbb60ul9O4a5qi5FtnOjFC2v/Ruk2binJ7vEm', '1561', NULL, 1, '2025-09-10', 1, 1, '2025-08-30 18:53:07', '2025-11-10 19:07:27');

-- ----------------------------
-- Table structure for user_favorite
-- ----------------------------
DROP TABLE IF EXISTS `user_favorite`;
CREATE TABLE `user_favorite`  (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT 'Favorite ID',
  `user_id` bigint NOT NULL COMMENT 'User ID',
  `article_id` varchar(36) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'Article ID',
  `created_at` datetime NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Favorite time',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `user_article_unique`(`user_id` ASC, `article_id` ASC) USING BTREE,
  INDEX `article_id`(`article_id` ASC) USING BTREE,
  CONSTRAINT `user_favorite_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT,
  CONSTRAINT `user_favorite_ibfk_2` FOREIGN KEY (`article_id`) REFERENCES `knowledge_article` (`id`) ON DELETE CASCADE ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 9 CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci COMMENT = 'User favorites table' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of user_favorite
-- ----------------------------
INSERT INTO `user_favorite` VALUES (8, 2, '550e8400-e29b-41d4-a716-446655440007', '2025-11-10 19:06:27');

SET FOREIGN_KEY_CHECKS = 1;