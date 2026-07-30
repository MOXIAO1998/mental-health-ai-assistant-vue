<template>
    <div class="navbar">
        <div class="flex-box">
            <el-button @click="handleCollpase">
                <el-icon><el-icon>
                        <Expand />
                    </el-icon></el-icon>
            </el-button>
            <p class="page-title">{{ route.meta.title }}</p>
        </div>
        <div class="flex-box">
            <el-dropdown @command="handleCommand">
                <div class="flex-box">
                    <el-avatar src="https://cube.elemecdn.com/0/88/03b0d39583f48206768a7534e55bcpng.png" />
                    <p class="user-name">admin</p>
                    <el-icon>
                        <ArrowDown />
                    </el-icon>
                </div>
                <template #dropdown>
                    <el-dropdown-menu>
                        <el-dropdown-item command="logout">Logout</el-dropdown-item>
                    </el-dropdown-menu>
                </template>
            </el-dropdown>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import { useAdminStore } from '../stores/admin';
import { useRouter, useRoute } from 'vue-router'
import { ElMessageBox } from 'element-plus';
import { logout } from '@/api/admin'


const router = useRouter()
const route = useRoute()


const handleCommand = (command) => {
    if (command === 'logout') {
        //logout
        ElMessageBox.confirm('Want to Logout?', 'Notification', {
            confirmButtonText: 'Logout',
            cancelButtonText: 'Cancel',
            type: 'warning'
        }).then(()=>{
            logout().then(()=>{
                localStorage.removeItem('token')
                localStorage.removeItem('userInfo')

                router.push('/auth/login')
            })
        })

    }
}

const handleCollpase = () => {
    useAdminStore().toggleCollpase()
}
</script>


<style lang="scss" scoped>
.navbar {
    height: 100%;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0px 15px;
    background: white;
    box-shadow: 0 1px 4px rgba(0, 21, 41, 0.08);
    border-bottom: 1px solid #e5e7eb;

    .flex-box {
        display: flex;
        align-items: center;
        justify-content: center;
    }

    .page-title {
        margin-left: 20px;
        font-size: 26px;
        font-weight: bold;
        color: #1f2937;
    }


}
</style>