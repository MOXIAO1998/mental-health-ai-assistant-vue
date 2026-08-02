<template>
    <div class="container">
        <div class="title">
            <div class="title-text">
                <h2>Create Your Accounut</h2>
                <p>Please Fill Register Information</p>
            </div>
        </div>
        <div class="form-container">
            <el-form label-position="top" :model="formData" :rules="rules" ref="submitFormRef">
                <el-form-item label="Username or Email" prop="username">
                    <el-input v-model="formData.username" placeholder="Please Enter Username" size="large" />
                </el-form-item>
                <el-form-item label="Email" prop="email">
                    <el-input v-model="formData.email" placeholder="Please Enter Email" size="large" />
                </el-form-item>
                <el-form-item label="Nickname" prop="nickname">
                    <el-input v-model="formData.nickname" placeholder="Please Enter Nickname(Optional)" size="large" />
                </el-form-item>
                <el-form-item label="Phone" prop="phone">
                    <el-input v-model="formData.phone" placeholder="Please Enter Phone Number(Optional)" size="large" />
                </el-form-item>
                <el-form-item label="Password" prop="password">
                    <el-input v-model="formData.password" placeholder="Please Enter Password" size="large" type="password" show-password />
                </el-form-item>
                <el-form-item label="Confirm Password" prop="confirmPassword">
                    <el-input v-model="formData.confirmPassword" placeholder="Please Enter Password Again" size="large" type="password" show-password />
                </el-form-item>
                <el-form-item>
                    <el-button class="btn" type="primary" size="large" @click="submitForm(submitFormRef)">Register</el-button>
                </el-form-item>
            </el-form>
        </div>
    </div>

</template>
<script setup>
import { ref, reactive } from 'vue'
import { register } from '@/api/frontend'
import { ElMessage } from 'element-plus'
import { useRouter } from 'vue-router'
const router = useRouter()
const formData = reactive({
    "username": "",
    "email": "",
    "nickname": "",
    "phone": "",
    "password": "",
    "confirmPassword": "",
    "gender": 0,
    "userType": 1 // 1 is normal user
})

const rules = reactive({
    "username": [
        { required: true, message: "Please Enter Username", trigger: "blur" }
    ],
    "email": [
        { required: true, message: "Please Enter Email", trigger: "blur" }
    ],
    "password": [
        { required: true, message: "Please Enter Password", trigger: "blur" }
    ],
    "confirmPassword": [
        { required: true, message: "Please Enter Password Again", trigger: "blur" }
    ]
})

// form submit

const submitFormRef = ref(null)
const submitForm = async (formEl) => {
    if (!formEl) return
    formEl.validate(async (valid) => {
        register(formData).then(({ data }) => {
            console.log(data)
            if (!data) {
                ElMessage.success('Successfully Registered')
                // succesfully register and back to login page
                router.push('/auth/login')
            }
            if (data.code === "BUSINESS_ERROR") {
               ElMessage.error(data.message)
            }
        })
    })
}
</script>

<style scoped lang="scss">.container {
    width: 384px;
    .flex-box {
        display: flex;
        align-items: center;
    }
    .title {
        .title-text {
            text-align: center;
            h2 {
                font-size: 36px;
                margin-bottom: 10px;
            }
            p {
                font-size: 18px;
                color: #6b7280;
            }
        }
    }
    .form-container {
        margin-top: 30px;
        .btn {
            margin-top: 40px;
            width: 100%;
        }
        .footer {
            padding: 30px;
            text-align: center;
        }
    }
}
</style>
