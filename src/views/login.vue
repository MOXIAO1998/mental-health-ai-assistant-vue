<template>
    <div class="container">
        <div class="title">
            <div class="back-home">
                <el-icon>
                    <Back />
                </el-icon>
                <span>Return Home</span>
            </div>
            <div class="title-text">
                <h2>Login Account</h2>
                <p>Please Enter Your Login Information</p>
            </div>
        </div>
        <div class="form-container">
            <el-form ref="ruleFormRef" :model="formData" :rules="rules" label-position="top">
                <el-form-item label="Username or Email" prop="username">
                    <el-input v-model="formData.username" size="large" placeholder="Please Enter Username" />
                </el-form-item>
                <el-form-item label="Password" prop="password">
                    <el-input v-model="formData.password" size="large" placeholder="Please Enter Password"
                        type="password" show-password />
                </el-form-item>
                <el-button class="btn" size="large" type="primary" @click="submitForm(ruleFormRef)">
                    Login
                </el-button>
            </el-form>
            <div class="footer">
                <p>Need an account? <router-link to="/auth/register">Register</router-link> </p>
            </div>

        </div>
    </div>
</template>


<script setup>
import { ref, reactive } from 'vue'
import { login } from '@/api/admin'
import { useRouter, useRoute } from 'vue-router'
const ruleFormRef = ref()
const route = useRoute()


const formData = reactive({
    username: '',
    password: ''
})


const rules = reactive({
    username: [
        { required: true, message: 'Please Enter Username', trigger: 'blur' }
    ],
    password: [
        { required: true, message: 'Please Enter Password', trigger: 'blur' }
    ]
})


//login
const router = useRouter()

const submitForm = async (formEl) => {
    if (!formEl) return
    await formEl.validate((valid, fields) => {
        if (valid) {
            login(formData).then(data => {
                if (!data.token) {
                    return console.error('Logon failed')
                }

                localStorage.setItem('token', data.token)
                localStorage.setItem('userInfo', JSON.stringify(data.userInfo))

                // return to where the user was headed before login expired, else dashboard
                const redirect = route.query.redirect
                if (redirect) {
                    router.push(redirect)
                } else if (data.userInfo.userType === 2) {
                    // admin
                    router.push('/back/dashboard')
                } else {
                    //
                }
            })
        }
    })
}

</script>


<style scoped lang="scss">
.container {
    width: 384px;

    .title {
        .back-home {
            margin-bottom: 60px;
        }

        .title-text {
            text-align: center;

            h2 {
                font-size: 36px;
                margin-bottom: 10px;
            }

            p {
                font-size: 18px;
                color: #6b7280
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