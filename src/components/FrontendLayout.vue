<template>
    <div class="frontend-layout">
        <div class="navbar-container">
            <div class="brand-section">
                <el-image style="width: 50px; height: 50px" :src="iconUrl" alt="brand logo" class="brand-logo" />
                <h1 class="brand-name">Mental Health AI Assistant</h1>
            </div>
            <div class="nav-section">
                <router-link to="/" class="nav-link">Home</router-link>
                <router-link to="/consultation" class="nav-link" v-if="isLoggedIn">AI Consultation</router-link>
                <router-link to="/emotion-diary" class="nav-link" v-if="isLoggedIn">Emotion Diary</router-link>
                <router-link to="/knowledge" class="nav-link">Knowledge Base</router-link>
                <el-button v-if="isLoggedIn" class="logout-btn" @click="handleLogout">Logout</el-button>
                <template v-else>
                    <router-link to="/auth/login" class="nav-link">Login</router-link>
                    <router-link to="/auth/register" class="nav-link">
                        <el-button type="primary">Register</el-button>
                    </router-link>
                </template>
            </div>
        </div>
        <div class="main-content">
            <router-view></router-view>
        </div>
        <div class="footer-container">
            <div class="footer-bottom">
                <p>&copy; 2026 Mental Health AI Assistant. All rights reserved.</p>
            </div>
        </div>
    </div>
</template>
<script setup>
import { ref, onMounted } from 'vue'
import { logout } from '@/api/admin'
import { useRouter } from 'vue-router'


const router = useRouter()
const iconUrl = new URL('@/assets/images/robot.png', import.meta.url).href
const isLoggedIn = ref(false)


const handleLogout = () => {
    logout().then(() => {
        // clean cache
        localStorage.removeItem('token')
        localStorage.removeItem('userInfo')
        // back to login page
        router.push('/auth/login')
    })
}

onMounted(() => {
    isLoggedIn.value = (localStorage.getItem('token') !== null)
})


</script>

<style scoped lang="scss">
.frontend-layout {
    background-color: #fff;

    .navbar-container {
        max-width: 1200px;
        height: 100%;
        margin: 0 auto;
        padding: 10px;
        display: flex;
        align-items: center;
        justify-content: space-between;

        .brand-section {
            display: flex;
            align-items: center;

            .brand-name {
                margin-left: 10px;
                font-size: 24px;
                font-weight: 600;
                color: #333;
            }
        }

        .nav-section {
            display: flex;
            align-items: center;
            gap: 40px;

            .nav-link {
                color: #4b5563;
                font-size: 16px;
                font-weight: 500;

                &:hover {
                    color: #4A90E2;
                }
            }
        }
    }

    .footer-container {
        background: #1f2937;
        color: white;
        padding: 15px 0;
        margin-top: auto;

        .footer-bottom {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 10px;
            text-align: center;
        }
    }
}
</style>