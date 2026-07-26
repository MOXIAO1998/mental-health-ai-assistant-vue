<template>
    <div>
        <PageHead title="Knowledge Articles">
            <template #buttons>
                <el-button @click="handleEdit({})" type="primary">
                    Add
                </el-button>

            </template>
        </PageHead>
        <TableSearch :formItem="formItem" @search="handleSearch" />
        <el-table :data="tableData" style="width: 100%;margin-top:25px">
            <el-table-column width="450" label="Article Title" fixed="left">
                <template #default="scope">
                    <div style="display: flex;align-items: center">
                        <el-icon>
                            <timer />
                        </el-icon>
                        <span>{{ scope.row.title }}</span>
                    </div>
                </template>
            </el-table-column>

            <el-table-column label="Category" witdth="200">
                <template #default="scope">
                    <div style="display: flex;align-items: center">
                        <el-icon>
                            <timer />
                        </el-icon>
                        <span>{{ categoryMap[scope.row.categoryId] }}</span>
                    </div>
                </template>
            </el-table-column>
            <el-table-column prop="authorName" label="Author" width="150" />
            <el-table-column prop="readCount" label="Read Count" width="150" />
            <el-table-column prop="createdAt" label="Release Time" width="150" />
            <el-table-column label="Actions" witdth="240" fixed="right">
                <template #default="scope">
                    <el-button @click="handleEdit(scope.row)" text type="primary">Edit</el-button>
                    <el-button v-if="scope.row.status === 0 || scope.row.status === 2" text
                        type="success">Publish</el-button>
                    <el-button v-if="scope.row.status === 1" text type="warning">Offline</el-button>
                    <el-button text type="danger">Delete</el-button>
                </template>
            </el-table-column>
        </el-table>
        <el-pagination style="margin-top: 25px;" :page-size="pagination.size" layout="prev,pager,next"
            :total="pagination.total" @change="handleChange" />
        <ArticleDialog v-model:modelValue="dialogVisible" :article="currentArticle" :categories="categories"
            @success="handleSuccess" />
    </div>
</template>


<script setup>
import { onMounted, ref, reactive } from 'vue';
import PageHead from '@/components/PageHead.vue';
import TableSearch from '@/components/TableSearch.vue';
import { categoryTree, articlePage, getArticleDetail } from '@/api/admin';
import ArticleDialog from '@/components/ArticleDialog.vue';

const formItem = [
    {
        comp: 'input',
        prop: 'title',
        label: "Article Title",
        placeholder: 'Please enter article title'
    },
    {
        comp: 'select',
        prop: 'categoryId',
        label: "Category",
        placeholder: "Please select category"
    },
    {
        comp: 'select',
        prop: 'status',
        label: "Status",
        placeholder: "Please enter article content",
        options: [
            {
                label: 'Draft',
                value: '0'
            },
            {
                label: 'Published',
                value: '1'
            },
            {
                label: 'Offline',
                value: '2'
            }
        ]
    }


]

const pagination = reactive({
    currentPage: 1,
    size: 10,
    total: 0
})


const handleSearch = async (formData) => {

    const params = {
        ...pagination,
        ...formData
    }

    const { records, total } = await articlePage(params)
    tableData.value = records
    pagination.total = total
}

const handleChange = (page) => {
    pagination.currentPage = page
    handleSearch()
}

// Chinese (from API) -> English (for display).
// Unmapped names fall back to the original so nothing breaks if the backend adds a category.
const categoryNameMap = {
    '人际关系': 'Relationships',
    '压力缓解': 'Stress Management',
    '心理健康基础': 'Mental Health Basics',
    '情绪管理': 'Emotion Regulation'
}
const translateCategory = (name) => categoryNameMap[name] ?? name

// category map
const categoryMap = reactive({})
// category list
const categories = ref([])
// table data
const tableData = ref([])
// add and edit
const dialogVisible = ref(false)
const currentArticle = ref(null)

const handleSuccess = () => {

}

// Edit
const handleEdit = (row) => {
    if (!row.id) {
        // add
        dialogVisible.value = true
        currentArticle.value = null

    } else {
        // edit
        getArticleDetail(row.id).then(res => {
            currentArticle.value = res
            dialogVisible.value = true
        })
    }

}




onMounted(async () => {
    const data = await categoryTree()


    // content comes from API, translating to English
    categories.value = data.map(item => {
        const label = translateCategory(item.categoryName)
        categoryMap[item.id] = label
        return {
            label,
            value: item.id
        }
    })
    formItem[1].options = categories.value

    // get the list
    handleSearch()
})



</script>