<template>
    <el-dialog :title="isEdit ? 'Edit Article' : 'Add Article'" v-model="dialogVisible" width="50%"
        @close="handleClose">

        <el-form :model="formData" :rules="rules" ref="formRef" label-width="120px">
            <el-form-item label="Article Title" prop="title">
                <el-input v-model="formData.title" placeholder="Please Enter Article Title" maxlength="200"
                    show-word-limit clearable></el-input>
            </el-form-item>

            <el-form-item label="Category" prop="categoryId">
                <el-select v-model="formData.categoryId" placeholder="Please Select Category">
                    <el-option v-for="item in props.categories" :key="item.value" :label="item.label"
                        :value="item.value" />
                </el-select>
            </el-form-item>

            <el-form-item label="Article Summary" prop="summary">
                <el-input type="textarea" v-model="formData.summary"
                    placeholder="Please Select Article Summary(Optional)" maxlength="1000" show-word-limit :rows="4" />
            </el-form-item>

            <el-form-item label="Tags" prop="tags">
                <el-select v-model="formData.tagArray" placeholder="Please Select Article Tags(separated by commas)"
                    multiple filterable allow-create style="width: 100%;">
                    <el-option v-for="tag in commonTags" :key="tag" :label="tag" :value="tag" />
                </el-select>
            </el-form-item>

            <el-form-item label="Cover Image">
                <div class="cover-upload">
                    <el-upload class="avatar-uploader" action="#" :before-upload="beforeUpload"
                        :http-request="handleUploadRequest" :show-file-list="false" accept="image/*">

                        <div v-if="!imgUrl" class="cover-placeholder">
                            <p>Upload Cover Image</p>
                        </div>

                        <img v-else :src="imgUrl" class="cover-image" alt="Image Cover">

                    </el-upload>
                    <div v-if="imgUrl" class="cover-remove">
                        <el-button type="danger" size="mini" @click="handleRemove">
                            Remove
                        </el-button>
                    </div>
                </div>

            </el-form-item>
            <el-form-item label="Article Content" prop="content">
                <RichTextEditor v-model="formData.content" placeholder="Please Enter Article Content."
                    :maxCharCount="5000" @change="handleContentChange" @created="handleEditorCreated"
                    min-height="400px" />
            </el-form-item>
        </el-form>
        <div v-if="btnPreview">
            <h3>Preview Content</h3>
            <div v-html="formData.content"></div>
        </div>
        <template #footer>
            <el-button @click="btnPreview = !btnPreview">{{ btnPreview ? 'Hide Preview' : 'Preview' }}</el-button>
            <el-button type="primary" @click="handleSubmit" :loading="loading">{{ isEdit ? 'Update' : 'Submit'
            }}</el-button>
            <el-button @click="dialogVisible = false">Close</el-button>
        </template>
    </el-dialog>

</template>


<script setup>
import { ref, reactive, computed, nextTick, watch } from 'vue'
import { ElMessage } from 'element-plus'
import { uploadFile, createArticle, updateArticle } from '@/api/admin'
import { fileBaseUrl } from '@/config/index.js'
import RichTextEditor from '@/components/RichTextEditor.vue'


const props = defineProps({
    modelValue: {
        type: Boolean,
        default: false
    },
    categories: {
        type: Array,
        default: () => []
    },
    article: {
        type: Object,
        default: null
    }

})

const emit = defineEmits(['update:modelValue', 'success'])


const dialogVisible = computed({
    get() {
        return props.modelValue
    },
    set(val) {
        emit('update:modelValue', val)
    }
})


const isEdit = computed(() => !!props.article?.id)

// watch edit data
watch(() => props.article, (newVal) => {
    if (newVal) {
        nextTick(() => {
            Object.assign(formData, newVal)
            // use existing ID
            businessId.value = newVal.id
            // cover URL
            imgUrl.value = fileBaseUrl + newVal.coverImage
        })

    }
})

const handleClose = () => {
    // reset form
    formRef.value.resetFields()
    businessId.value = null
    formData.tagArray = []
    handleRemove()

    emit('update:modelValue', false)
}

// form data
const formData = reactive(
    {
        "title": "",
        "content": "",
        "coverImage": "",
        "categoryId": "",
        "summary": "",
        "tags": "",
        "id": ""
    }
)


const rules = reactive(
    {
        title: [
            { required: true, message: 'Please Enter Article Title', trigger: "blur" },
            { max: 200, message: 'Article title must be 200 characters or fewer.', trigger: "blur" }

        ],
        categoryId: [
            { required: true, message: 'Please Select Category', trigger: 'change' }
        ],
        content: [
            { required: true, message: 'Please Enter Article Content', trigger: "blur" },
            { max: 5000, message: 'Article Content must be 5000 characters or fewer.', trigger: "blur" }

        ]
    }
)


const commonTags = [
    'Emotion Regulation', 'Anxiety', 'Depression', 'Stress', 'Sleep',
    'Meditation', 'Mindfulness', 'Relaxation', 'Mental Health', 'Personal Growth',
    'Relationships', 'Work Stress', 'Study Strategies', 'Life Skills'
]



const imgUrl = ref('')
const beforeUpload = (file) => {
    // validation about type and size
    const isImage = file.type.startsWith('image/')
    const isLt5M = file.size / 1024 / 1024 < 5 // file size is bit, / 1024 to kb / 1024 to mb
    if (!isImage) {
        ElMessage.error('Upload cover image, please selet image file')
        return false
    }
    if (!isLt5M) {
        ElMessage.error('Upload cover image, image size should be less than 5 MB')
        return false
    }
    return true
}

const businessId = ref(null)

const handleUploadRequest = async ({ file }) => {
    // unique identifier by UUID
    businessId.value = crypto.randomUUID()

    const fileRes = await uploadFile(file, {
        businessId: businessId.value
    })

    // concate image address
    imgUrl.value = fileBaseUrl + fileRes.filePath
    formData.coverImage = fileRes.filePath

}

const handleRemove = () => {
    imgUrl.value = ''
    formData.coverImage = ''
}

const handleContentChange = (data) => {
    formData.content = data.html
}

const editorInstance = ref(null)

const handleEditorCreated = (editor) => {
    editorInstance.value = editor
    //  edit
    if (formData.content && editor) {
        nextTick(() => {
            editor.setHtml(formData.content)
        })
    }
}


const btnPreview = ref(false)

//submit
const formRef = ref()
const loading = ref(false)
const handleSubmit = () => {
    formRef.value.validate((valid, field) => {
        if (valid) {
            loading.value = true
        }

        const submitData = {
            ...formData,
            tags: formData.tagArray.join(',')
        }

        delete submitData.tagArray

        if (!isEdit.value) {
            submitData.id = businessId.value
            createArticle(submitData).then(res => {
                loading.value = false
                emit('success')
            })
        } else {
            updateArticle(props.article.id,submitData).then(res => {
                loading.value = false
                emit('success')
            })
        }



    })
}

</script>


<style lang="scss" scoped>
.cover-placeholder {
    width: 200px;
    height: 120px;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    color: #8b949e;
    background: #f6f8fa;
}

.cover-image {
    width: 200px;
    height: 120px;
    display: block;
}
</style>