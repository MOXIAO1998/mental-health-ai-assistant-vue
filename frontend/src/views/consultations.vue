<template>
    <div>
        <PageHead title="Consultation Records" />
        <el-table :data="tableData" style="width: 100%;">
            <el-table-column label="Session ID" width="100">
                <template #default="scope">
                    <el-avatar>
                        {{ scope.row.userNickname }}
                    </el-avatar>
                </template>
            </el-table-column>

            <el-table-column label="Emotion Logs">
                <template #default="scope">
                    <div class="session-title">{{ scope.row.sessionTitle }}</div>
                    <div class="session-preview">{{ scope.row.lastMessageContent }}</div>
                </template>
            </el-table-column>
            <el-table-column prop="messageCount" label="Message Count" width="100" />
            <el-table-column prop="lastMessageTime" label="Time" width="100" />
            <el-table-column label="Actions" width="100">
                <template #default="scope">
                    <el-button type="primary" text @click="viewSessionDetail(scope.row)">Detail</el-button>
                </template>
            </el-table-column>


        </el-table>
        <el-pagination style="margin-top: 25px;" :page-size="pagination.size" layout="prev,pager,next"
            :total="pagination.total" @change="handleChange" />
        <el-dialog v-model="showDetailDialog" title="Consultation Session Detail" width="70%"
            :close-on-click-modal="false">
            <div class="session-detail">
                <div class="detail-header">
                    <div class="detail-row">
                        <div class="detail-label">User: </div>
                        <div class="detail-value">{{ sessionDetail.userNickname }}</div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Start Time: </div>
                        <div class="detail-value">{{ sessionDetail.startedAt }}</div>
                    </div>

                    <div class="detail-row">
                        <div class="detail-label">Message Counut: </div>
                        <div class="detail-value">{{ sessionDetail.messageCount }}</div>
                    </div>
                </div>
                <div class="messages-container">
                    <div class="messages-header">
                        <h4>Message History</h4>
                    </div>
                    <div class="messages-list" v-loading="loadingMessage">
                        <div v-for="message in sessionMessages" :key="message.id" class="message-item"
                            :class="message.senderType === 1 ? 'user-message' : 'ai-message'">
                            <div class="message-header">
                                <span class="sender">
                                    {{ message.senderType === 1 ? 'User' : 'AI-Assistant' }}
                                </span>
                                <span class="time">{{ message.createdAt }}</span>
                            </div>
                            <div class="message-content">{{ message.content }}</div>
                        </div>
                    </div>
                </div>
            </div>
            <template #footer>
                <el-button @click="showDetailDialog = false">Close</el-button>
            </template>
        </el-dialog>
    </div>

</template>


<script setup>
import { onMounted, ref, reactive } from 'vue';
import PageHead from '@/components/PageHead.vue'
import { getConsultationPage, getSessionDetail } from '@/api/admin';

const tableData = ref([])

const pagination = reactive({
    currentPage: 1,
    size: 10,
    total: 0
})

const sessionDetail = ref({})
const sessionMessages = ref({})
const loadingMessage = ref(false)



const viewSessionDetail = (row) => {
    loadingMessage.value = true
    showDetailDialog.value = true

    getSessionDetail(row.id).then(res => {
        loadingMessage.value = false
        sessionMessages.value = res
        sessionDetail.value = row
    })
}

const handleChange = (page) => {
    pagination.currentPage = page
    handleSearch()
}

const handleSearch = () => {
    getConsultationPage(pagination).then(res => {
        const { records, total } = res
        console.log(records)
        tableData.value = records
        pagination.total = total
    })
}

// Detail of Dialog
const showDetailDialog = ref(false)


onMounted(() => {
    handleSearch()
})

</script>


<style>
.session-title {
    font-weight: 500;
    color: #333;
    margin-bottom: 4px;
}

.session-preview {
    font-size: 13px;
    color: #666;
    margin-bottom: 4px;
    display: -webkit-box;
    -webkit-line-clamp: 2;
    line-clamp: 2;
    -webkit-box-orient: vertical;
    overflow: hidden;
}

.session-detail {
    max-height: 70vh;
    overflow-y: auto;

    .detail-header {
        margin-bottom: 20px;
        padding: 16px;
        background: #f8f9fa;
        border-radius: 8px;
        border: 1px solid #e9ecef;
    }

    .detail-row {
        display: flex;
        align-items: center;
        margin-bottom: 8px;

        :last-child {
            margin-bottom: 0;
        }

        .detail-label {
            font-weight: 500;
            color: #495057;
            min-width: 80px;
            margin-right: 8px;
        }

        .detail-value {
            color: #333;
        }
    }
}

.messages-container {
    margin-top: 20px;

    .messages-header {
        margin-bottom: 16px;

        h4 {
            margin: 0;
            color: #333;
            font-size: 16px;
            font-weight: 500;
        }
    }

    .messages-list {
        max-height: 400px;
        overflow-y: auto;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        padding: 16px;
        background: #fff;

        .message-item {
            margin-bottom: 12px;
            padding: 12px;
            border-radius: 8px;
            background: #f8f9fa;
            border: 1px solid #e9ecef;

            :last-child {
                margin-bottom: 0;
            }

            &.user-message {
                background: #e8f4fd;
            }

            &.ai-message {
                background: #f0f9f0;
            }
        }

        .message-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;

            .sender {
                font-weight: 500;
                color: #333;
                display: flex;
                align-items: center;
                gap: 4px;
            }

            .time {
                font-size: 12px;
                color: #999;
            }

            .message-content {
                color: #333;
                line-height: 1.6;
                white-space: pre-wrap;
                margin-top: 8px;
                font-size: 14px;
            }
        }
    }
}
</style>