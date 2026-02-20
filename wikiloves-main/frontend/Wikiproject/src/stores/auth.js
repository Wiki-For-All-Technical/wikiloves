import { ref, computed } from 'vue'
import { defineStore } from 'pinia'
import axios from 'axios'

const isDev = import.meta.env.DEV
const AUTH_BASE = isDev ? '/toolforge-api/auth' : '/api/auth'

export const useAuthStore = defineStore('auth', () => {
  const user = ref(null)
  const isAdmin = ref(false)
  const loading = ref(false)
  const checked = ref(false)

  const isLoggedIn = computed(() => !!user.value)

  async function fetchUser() {
    if (checked.value) return
    loading.value = true
    try {
      const { data } = await axios.get(AUTH_BASE + '/user', { withCredentials: true })
      user.value = data.user
      isAdmin.value = data.is_admin ?? false
    } catch {
      user.value = null
      isAdmin.value = false
    } finally {
      loading.value = false
      checked.value = true
    }
  }

  function login() {
    const base = isDev
      ? 'https://wikiloves-data.toolforge.org/api/auth/login'
      : '/api/auth/login'
    window.location.href = base
  }

  async function logout() {
    try {
      await axios.post(AUTH_BASE + '/logout', null, { withCredentials: true })
    } catch {
      // ignore
    }
    user.value = null
    isAdmin.value = false
    checked.value = false
  }

  return { user, isAdmin, isLoggedIn, loading, checked, fetchUser, login, logout }
})
