import {createRouter, createWebHistory} from 'vue-router'
import BackendLayout from '@/components/BackendLayout.vue'

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
                    title: 'Emotion Log',
                    icon: 'User'
                }
            }

        ]
    }
]


const router =  createRouter({
    history: createWebHistory(),
    routes: backendRoutes
})

export default router