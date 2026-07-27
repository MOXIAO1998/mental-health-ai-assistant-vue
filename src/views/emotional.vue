<template>
    <div>
        <PageHead title="Emotion Diary" />
        <TableSearch :formItem="formItem" @search="handleSearch" />
        <el-table :data="tableData" style="width: 100%;">
            <el-table-column prop="id" label="User ID" width="80" />
            <el-table-column label="Session ID" width="80">
                <template #default="scope">
                    <el-avatar>{{ scope.row.nickname }}</el-avatar>
                </template>
            </el-table-column>

            <el-table-column prop="diaryDate" label="Diary Date" width="120" />
            <el-table-column label="Emotion Score">
                <template #default="scope">
                    <el-rate :model-value="scope.row.moodScore" :max="10" disabled />
                </template>
            </el-table-column>
            <el-table-column label="Life Indicator" width="120">
                <template #default="scope">
                    <div>
                        <p>Sleep: {{ scope.row.sleepQuality }}/5</p>
                        <p>Stress: {{ scope.row.stressLevel }}/5</p>
                    </div>
                </template>
            </el-table-column>
            <el-table-column prop="emotionTriggers" label="Emotion Tiggers" width="120" />
            <el-table-column prop="diaryContent" label="Diary Content" width="250" />
            <el-table-column label="Actions" witdth="240" fixed="right">
                <template #default="scope">
                    <el-button @click="viewSessionDetail(scope.row)" text type="primary">Detail</el-button>
                    <el-button @click="handleDelete(scope.row)" text type="danger">Delete</el-button>
                </template>
            </el-table-column>
        </el-table>
        <el-pagination style="margin-top: 25px" :page-size="pagination.size" layout="prev,pager,next"
            :total="pagination.total" @change="handleChange" />
        <el-dialog v-model="detailDialogVisible" title="Emotion Diary" width="800px" :close-on-click-modal="false">
            <div class="detail-content" v-if="currentDetail">
                <div class="detail-section">
                    <h4>User Information</h4>
                    <el-descriptions :column="2" border>
                        <el-descriptions-item label="Username">{{ currentDetail.username }}</el-descriptions-item>
                        <el-descriptions-item label="Nickname">{{ currentDetail.nickname }}</el-descriptions-item>
                        <el-descriptions-item label="User ID">{{ currentDetail.userId }}</el-descriptions-item>
                        <el-descriptions-item label="Diary Date">{{ currentDetail.diaryDate }}</el-descriptions-item>
                    </el-descriptions>
                </div>
                <div class="detail-section">
                    <h4>Emotion Status</h4>
                    <el-descriptions :column="2" border>
                        <el-descriptions-item label="Emotion Score">
                            <el-rate :model-value="currentDetail.moodScore" :max="10" disabled />
                        </el-descriptions-item>
                        <el-descriptions-item label="Dominant Emotion">
                            <el-tag :type="getEmotionTagType(currentDetail.dominantEmotion)">
                                {{ translateEmotion(currentDetail.dominantEmotion) }}
                            </el-tag>
                        </el-descriptions-item>
                        <el-descriptions-item label="Sleep Quality">{{ currentDetail.sleepQuality || '`-'
                        }}/5</el-descriptions-item>
                        <el-descriptions-item label="Stree Level">{{ currentDetail.stressLevel || '-'
                        }}/5</el-descriptions-item>
                    </el-descriptions>
                </div>
                <div class="detail-section">
                    <h4>Diary Content</h4>
                    <el-descriptions :column="1" border>
                        <el-descriptions-item label="Emotion Trigger">{{ currentDetail.emotionTriggers || 'None'
                        }}</el-descriptions-item>
                        <el-descriptions-item label="Diary Content">{{ currentDetail.diaryContent || 'None'
                        }}</el-descriptions-item>
                    </el-descriptions>
                </div>

                <div class="detail-section">
                    <h4>AI Emotion Analysis Result</h4>
                    <div class="ai-analysis-result">
                        <el-descriptions :column="2" border>
                            <el-descriptions-item label="Dominant Emotion">
                                <el-tag :type="getAiEmotionTagType(aiData.primaryEmotion)"> {{
                                    translateEmotion(aiData.primaryEmotion)
                                }}</el-tag>
                            </el-descriptions-item>
                            <el-descriptions-item label="Emotion Intensity">
                                <el-progress :percentage="aiData.emotionScore"
                                    :color="getEmotionScoreColor(aiData.emotionScore)" :stroke-width="8" />
                            </el-descriptions-item>
                            <el-descriptions-item label="Risk Level">
                                <el-tag :type="getAiEmotionTagType(aiData.riskLevel)">{{ aiData.riskLevel }}</el-tag>
                            </el-descriptions-item>
                            <el-descriptions-item label="Emotion Quality">
                                <el-tag :type="aiData.isNegative ? 'danger' : 'success'">{{ aiData.isNegative
                                    ? 'Negative' : 'Positive'
                                }}</el-tag>
                            </el-descriptions-item>
                        </el-descriptions>
                        <div class="ai-suggestion-section">
                            <h5>Suggestion</h5>
                            <div class="suggestion-content">{{ aiData.suggestion || 'None' }}</div>
                        </div>
                        <div class="ai-risk-section">
                            <h5>Risk Description</h5>
                            <div class="risk-content">{{ aiData.riskDescription || 'None' }}</div>
                        </div>
                        <div class="ai-improvements-section">
                            <h5>Improvement Suggestion</h5>
                            <ul class="improvement-list">
                                <li v-for="item in aiData.improvementSuggestions" :key="item">{{ item }}</li>
                            </ul>
                        </div>


                    </div>
                </div>
                <div class="detail-section">
                    <h4>Date Information</h4>
                    <el-descriptions :column="2" border>
                        <el-descriptions-item label="Create Date">{{ currentDetail.createdAt }}</el-descriptions-item>
                        <el-descriptions-item label="Update Date">{{ currentDetail.updatedAt }}</el-descriptions-item>
                    </el-descriptions>
                </div>
            </div>
            <template #footer>
                <el-button @click="detailDialogVisible = false">Close</el-button>
            </template>
        </el-dialog>
    </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import PageHead from '@/components/PageHead.vue'
import TableSearch from '@/components/TableSearch.vue'
import { getEmotionalPage, deleteEmotional } from '@/api/admin'
import { ElMessageBox } from 'element-plus'


// Chinese (from API) -> English (for display).
// Unmapped values fall back to the original so nothing breaks if the backend adds an emotion.
const emotionNameMap = {
    '开心': 'Happy',
    '平静': 'Calm',
    '兴奋': 'Excited',
    '满足': 'Content',
    '愤怒': 'Angry',
    '悲伤': 'Sad',
    '焦虑': 'Anxious',
    '恐惧': 'Fearful',
    '沮丧': 'Depressed',
    '压力': 'Stressed'
}
const translateEmotion = (emotion) => emotionNameMap[emotion] ?? emotion

const getEmotionTagType = (emotion) => {
    const emotionTypes = {
        '开心': 'success',
        '快乐': 'success',
        '平静': 'info',
        '兴奋': 'warning',
        '愤怒': 'danger',
        '悲伤': 'info',
        '焦虑': 'warning'
    }
    return emotionTypes[emotion] || 'info'
}

const getAiEmotionTagType = (emotion) => {
    const emotionTagMap = {
        '快乐': 'success',
        '平静': 'success',
        '兴奋': 'warning',
        '满足': 'success',
        '愤怒': 'danger',
        '悲伤': 'info',
        '焦虑': 'warning',
        '恐惧': 'danger',
        '沮丧': 'info',
        '压力': 'warning'
    }
    return emotionTagMap[emotion] || 'info'
}

const getEmotionScoreColor = (score) => {
    if (score >= 80) return '#f56c6c'
    if (score >= 60) return '#e6a23c'
    if (score >= 40) return '#909399'
    return '#67c23a'
}

const getRiskLevelTagType = (riskLevel) => {
    const riskTagMap = {
        0: 'success',
        1: 'info',
        2: 'warning',
        3: 'danger'
    }
    return riskTagMap[riskLevel] || 'info'
}

const getRiskLevelText = (riskLevel) => {
    const riskTextMap = {
        0: '正常',
        1: '关注',
        2: '预警',
        3: '危机'
    }
    return riskTextMap[riskLevel] || '未知风险等级'
}

const formItem = [
    { comp: 'input', prop: 'userId', label: 'User ID', placeholder: 'Please Enter user ID' },
    {
        comp: 'select', prop: 'emotionScoreRange', label: 'Emotion Score', placeholder: 'Please Select Score',
        options: [{
            label: 'Low(1-3)',
            value: '1-3'
        },
        {
            label: 'Medium(4-6)',
            value: '4-6'
        },
        {
            label: 'High(7-10)',
            value: '7-10'
        }]
    }
]


// List
const tableData = ref([])


// pagination
const pagination = reactive({
    currentPage: 1,
    size: 10,
    total: 0
})

const handleChange = (page) => {
    pagination.currentPage = page
    handleSearch()
}

const handleSearch = async (formData) => {
    const params = {
        ...pagination,
        ...formData
    }

    const { records, total } = await getEmotionalPage(params)
    tableData.value = records
    pagination.total = total

}

const detailDialogVisible = ref(false)
const currentDetail = ref(null)
const aiData = ref(null)

const viewSessionDetail = (row) => {
    currentDetail.value = row
    if (row.aiEmotionAnalysis) {
        aiData.value = JSON.parse(row.aiEmotionAnalysis)
        console.log(aiData.value)
    } else {
        aiData.value = {}
    }


    detailDialogVisible.value = true
}

const handleDelete = (row) => {
    ElMessageBox.confirm('Delete the Session?', 'Confirm Delete', {
        confirmButtonText: 'Confirm',
        cancelButtonText: 'Cancel',
        type: 'danger'
    }).then(() => {
        deleteEmotional(row.id).then(() => {
            handleSearch()
        })
    })
}


onMounted(() => {
    handleSearch()
})


</script>

<style>
.detail-content {
    .detail-section {
        margin-bottom: 24px;

        h4 {
            margin: 0 0 16px 0;
            color: #303133;
            font-size: 16px;

            i {
                margin-right: 8px;
                color: #409eff;
            }
        }
    }
}

// AI分析相关样式
.ai-analysis-status {
    .ai-status-tag {
        margin-bottom: 4px;

        i {
            margin-right: 4px;
        }
    }

    .ai-analysis-preview {
        font-size: 11px;
        color: #909399;
        margin-top: 2px;
    }
}

.ai-analysis-result {

    .ai-keywords-section,
    .ai-suggestion-section,
    .ai-risk-section,
    .ai-improvements-section {
        margin-top: 16px;
        padding: 12px;
        background-color: #f8f9fa;
        border-radius: 4px;

        h5 {
            margin: 0 0 8px 0;
            color: #606266;
            font-size: 14px;
            font-weight: 600;

            i {
                margin-right: 6px;
                color: #909399;
            }
        }
    }

    .keywords-container {
        display: flex;
        flex-wrap: wrap;
        gap: 6px;

        .keyword-tag {
            background-color: #e1f3d8;
            color: #67c23a;
            border-color: #b3d8a4;
        }
    }

    .suggestion-content,
    .risk-content {
        line-height: 1.6;
        color: #606266;
        background-color: white;
        padding: 8px;
        border-radius: 4px;
        border: 1px solid #ebeef5;
    }

    .improvement-list {
        margin: 0;
        padding-left: 20px;

        li {
            margin-bottom: 4px;
            color: #606266;
            line-height: 1.5;
        }
    }

    .ai-analysis-meta {
        margin-top: 16px;
        padding-top: 12px;
        border-top: 1px solid #ebeef5;

        .analysis-time {
            margin: 0;
            font-size: 12px;
            color: #909399;

            i {
                margin-right: 4px;
            }
        }
    }

    .el-progress {
        .el-progress__text {
            font-size: 12px !important;
        }
    }
}
</style>