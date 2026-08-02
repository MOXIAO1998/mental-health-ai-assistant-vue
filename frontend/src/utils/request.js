import axios from 'axios'
import { ElMessage } from 'element-plus'


// build axios instance
const service = axios.create({
    baseURL: '/api', //prefix of request
    timeout: 5000
})

// request interceptor
service.interceptors.request.use(
    (config) => {
        // something before send
        const token = localStorage.getItem('token')
        if (token) {
            config.headers['token'] = token
        }
        return config
    },
    (error) => {
        // something for request
        return Promise.reject(error)
    }
)

// redirect to login once — clears the expired token and guards against loops
let redirecting = false
const forceRelogin = (msg) => {
    ElMessage.error(msg || 'Session expired. Please log in again.')
    // clean stale login info so the next login starts fresh
    localStorage.removeItem('token')
    localStorage.removeItem('userInfo')
    if (!redirecting && !window.location.pathname.startsWith('/auth/login')) {
        redirecting = true
        // remember where the user was so we can return after re-login
        const redirect = encodeURIComponent(window.location.pathname + window.location.search)
        window.location.href = `/auth/login?redirect=${redirect}`
    }
}

// response interceptor
service.interceptors.response.use(
    (response) => {
        // something for response data
        const { data, config } = response
        const code = String(data?.code)
        const isLoginRequest = config.url?.includes('/login')

        // success
        if (code === '200') {
            return data.data
        }

        // expired / unauthorized reported in the response body
        if (code === '-1') {
            if (!isLoginRequest) {
                forceRelogin(data.msg)
            } else {
                ElMessage.error(data.msg || 'Session expired. Please log in again.')
            }
            return Promise.reject(new Error(data.msg || 'Session expired.'))
        }

        // any other business error: surface it and reject so callers' .then() is skipped
        ElMessage.error(data?.msg || 'Request failed.')
        return Promise.reject(new Error(data?.msg || 'Request failed.'))
    },
    (error) => {
        // HTTP-level errors — 401/403 mean the token is missing or expired
        const status = error.response?.status
        if (status === 401 || status === 403) {
            forceRelogin(error.response?.data?.msg)
        } else {
            ElMessage.error(error.response?.data?.msg || error.message || 'Network request failed.')
        }
        return Promise.reject(error)
    }
)

export default service