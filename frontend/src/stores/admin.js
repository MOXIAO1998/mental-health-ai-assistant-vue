import { defineStore } from "pinia";
import { ref } from 'vue'

export const useAdminStore = defineStore('admin', () => {
    const isCollapse = ref(false)

    const toggleCollpase = () => {
        isCollapse.value = !isCollapse.value
    }

    return {
        isCollapse,
        toggleCollpase
    }
})

