import {createRouter, createWebHistory} from 'vue-router'
import BackendLayout from '@/components/BackendLayout.vue'
import AuthLayout from '@/components/AuthLayout.vue'
import component from 'element-plus/es/components/tree-select/src/tree-select-option.mjs'
// Router Configuration
const backendRoutes = [
    {
        path: '/back',
        component:BackendLayout,
        children:[
            {
                path:'dashboard',
                component: ()=> import('@/views/dashboard.vue'),
                meta:{
                    title: 'Dashboard',
                    icon: 'PieChart'
                }
            },
            {
                path:'knowledge',
                component: ()=> import('@/views/knowledge.vue'),
                meta:{
                    title: 'Knowledge Articles',
                    icon: 'ChatLineSquare'
                }
            },
            {
                path:'consultations',
                component: ()=> import('@/views/consultations.vue'),
                meta:{
                    title: 'Consultation Records',
                    icon: 'Message'
                }
            },
            {
                path:'emotional',
                component: ()=> import('@/views/emotional.vue'),
                meta:{
                    title: 'Emotion Diary',
                    icon: 'User'
                }
            }

        ]
    },
    {
        path: '/auth',
        component: AuthLayout,
        children: [
            {
                path: 'login',
                component: () => import('@/views/login.vue'),
                meta: {
                    title: 'login'
                }
            },
            {
                path: 'register',
                component: () => import('@/views/register.vue'),
                meta: {
                    title: 'register'
                }
            }
        ]
    }
]


const router =  createRouter({
    history: createWebHistory(),
    routes: backendRoutes
})

// route guard: protected /back/* pages require a token; otherwise send to login
router.beforeEach((to, from, next) => {
    const token = localStorage.getItem('token')
    const isAuthPage = to.path.startsWith('/auth')

    if (!token && !isAuthPage) {
        // not logged in and heading somewhere protected -> go log in, remember target
        next({ path: '/auth/login', query: { redirect: to.fullPath } })
    } else if (token && isAuthPage) {
        // already logged in, no need to see the login page again
        next('/back/dashboard')
    } else {
        next()
    }
})

export default router