<template>
    <div class="emotionDiary-container">
        <div class="header-section">
            <div class="header-content">
                <el-image :src="iconUrl" style="width: 60px;height: 60px"></el-image>
                <h1>Emotion Diary</h1>
            </div>
        </div>
        <div class="content">
            <!-- 情绪评分 -->
            <div class="diary-card">
                <div class="title">Today's emotion rating</div>
                <div class="section">
                    <p>How would you rate your overall emotional state today? (1-10 points)</p>
                    <div class="rate">
                        <el-rate 
                            v-model="diaryForm.moodScore"
                            :texts="emotionStatus"
                            show-texts
                            :max="10"
                            size="large"
                        />
                    </div>
                </div>
            </div>
            <!-- 主要情绪 -->
            <div class="diary-card">
                <div class="title">Dominant Emotion</div>
                <div class="emotion-grid">
                    <div v-for="emotion in emotionOptions" :key="emotion.name" class="emotion-card" :class="{'selected': emotion.name === diaryForm.dominantEmotion}" @click="selectEmotion(emotion.name)">
                        <el-image :src="emotion.url" style="width: 50px;height: 50px"></el-image>
                        <div class="emotion-name">{{emotion.name}}</div>
                    </div>
                </div>
            </div>
            <!-- 详细记录 -->
            <div class="diary-card">
                <div class="title">Detail Record</div>
                <div class="detail-form">
                    <div class="form-group">
                        <div class="form-label">Emotional Triggers</div>
                        <el-input v-model="diaryForm.emotionTriggers" placeholder="What happened today that affected your mood?" type="textarea" :rows="3" maxLength="1000" show-word-limit></el-input>
                    </div>
                     <div class="form-group">
                        <div class="form-label">Thoughts on Today</div>
                        <el-input v-model="diaryForm.diaryContent" placeholder="Write down your thoughts, feelings or interesting things that happened today..." type="textarea" :rows="5" maxLength="2000" show-word-limit></el-input>
                    </div>
                    <!-- 生活指标 -->
                    <div class="life-indicators">
                        <div class="indicator-group">
                            <div class="form-label">Sleep Quality</div>
                           <el-select v-model="diaryForm.sleepQuality" placeholder="Please Select">
                                <el-option label="Worst" :value="1"></el-option>
                                <el-option label="Bad" :value="2"></el-option>
                                <el-option label="Normal" :value="3"></el-option>
                                <el-option label="Good" :value="4"></el-option>
                                <el-option label="Excellent" :value="5"></el-option>
                            </el-select>
                        </div>
                        <div class="indicator-group">
                            <div class="form-label">Stress Level</div>
                            <el-select v-model="diaryForm.stressLevel" placeholder="Please Select">
                                <el-option label="Lowest" :value="1"></el-option>
                                <el-option label="Low" :value="2"></el-option>
                                <el-option label="Medium" :value="3"></el-option>
                                <el-option label="High" :value="4"></el-option>
                                <el-option label="Highest" :value="5"></el-option>
                            </el-select>
                        </div>
                    </div>
                    <div class="action-buttons">
                        <el-button  @click="resetForm">Reset</el-button>
                        <el-button type="primary" @click="submit">Submit</el-button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
<script setup>
    import { dayjs, ElMessage } from 'element-plus'
    import { ref, reactive } from 'vue'
    import { addEmotionDiary } from '@/api/frontend'

    // 情绪评分
    const emotionStatus = ['despair', 'depression', 'agitated', 'displeased', 'calm', 'relaxed', 'pleased', 'satisfied', 'excited', 'Ultimately happy']

    // 情绪选项
    const emotionOptions = [
        { name: 'happy', url: new URL('@/assets/images/happy.png', import.meta.url).href },
        { name: 'calm', url: new URL('@/assets/images/calm.png', import.meta.url).href },
        { name: 'anxious', url: new URL('@/assets/images/anxious.png', import.meta.url).href },
        { name: 'sad', url: new URL('@/assets/images/sad.png', import.meta.url).href },
        { name: 'excited', url: new URL('@/assets/images/excited.png', import.meta.url).href },
        { name: 'tired', url: new URL('@/assets/images/tired.png', import.meta.url).href },
        { name: 'amazed', url: new URL('@/assets/images/amazed.png', import.meta.url).href },
        { name: 'confused', url: new URL('@/assets/images/confused.png', import.meta.url).href },
    ]

    const selectEmotion = (emotion) => {
        diaryForm.dominantEmotion = emotion
    }

    const diaryForm = reactive({    
        diaryDate: dayjs().format('YYYY-MM-DD'),
        moodScore: null,
        dominantEmotion: '',
        emotionTriggers: '',
        diaryContent: '',
        sleepQuality: null,
        stressLevel: null
    })

    const resetForm = () => {
        Object.assign(diaryForm, {
            diaryDate: dayjs().format('YYYY-MM-DD'),
            moodScore: null,
            dominantEmotion: '',
            emotionTriggers: '',
            diaryContent: '',
            sleepQuality: null,
            stressLevel: null
        })
    }

    const submit = () => {
        console.log(diaryForm)
        if (!diaryForm.moodScore) {
            ElMessage.error('Please Select Emotion Score')
            return
        }
        addEmotionDiary(diaryForm).then(() => {
            ElMessage.success('Submit Successfully')
            resetForm()
        })
    }

    const iconUrl = new URL('@/assets/images/like.png', import.meta.url).href
</script>
<style lang="scss" scoped>
    .emotionDiary-container {
    background: linear-gradient(135deg, #fafbfc 0%, #f7f9fc 50%, #f2f6fa 100%);
    .header-section {
        background: linear-gradient(135deg, #7ED321 0%, #F5A623 100%);
        color: white;
        padding: 48px;
        .header-content {
            display: flex;
            align-items: center;
            gap: 12px;
        }
    }
    .content {
        margin: 0 auto;
        width: 980px;
        padding: 20px;
        .diary-card {
            margin-bottom: 20px;
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
            .title {
                margin-bottom: 20px;
                font-size: 25px;
                font-weight: 600;
                color: #374151;
            }
            .section {
                margin-bottom: 20px;
                p {
                    font-size: 15px;
                    color: #6B7280;
                    margin-bottom: 15px;
                }
            }
            .emotion-grid {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 10px;
                .emotion-card {
                    display: flex;
                    flex-direction: column;
                    align-items: center;
                    justify-content: center;
                    padding: 13px;
                    border: 2px solid #E5E7EB;
                    border-radius: 15px;
                    text-align: center;
                    cursor: pointer;
                    background: #F9FAFB;
                    .emotion-name {
                        margin-top: 10px;
                        color: #374151;
                    }
                    &.selected {
                        border-color: #7ED321;
                        background: #F0FDF4;
                        transform: translateY(-3px);
                    }
                }
            }
            .detail-form {
                .form-label {
                    margin: 10px 0;
                    color: #374151;
                }
                .life-indicators {
                    display: flex;
                    gap: 20px;
                    .indicator-group {
                        flex: 1;
                    }
                }
                .action-buttons {
                    margin-top: 40px
                }
            }
        }
    }
}
</style>
