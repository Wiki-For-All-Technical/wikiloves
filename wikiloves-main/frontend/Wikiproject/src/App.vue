<script setup>
import { onMounted, ref } from 'vue'
import { RouterView, RouterLink } from 'vue-router'
import ToastContainer from '@/components/ToastContainer.vue'
import { setupKeyboardNavigation } from '@/utils/accessibility'
import { useAuthStore } from '@/stores/auth'

const auth = useAuthStore()
const userMenuOpen = ref(false)

const navLinks = [
  { label: 'Earth', to: '/earth' },
  { label: 'Monuments', to: '/monuments' },
  { label: 'Folklore', to: '/folklore' },
  { label: 'Science', to: '/science' },
  { label: 'Africa', to: '/africa' },
  { label: 'Food', to: '/food' },
  { label: 'Public Art', to: '/public_art' },
]

onMounted(() => {
  setupKeyboardNavigation()
  auth.fetchUser()
})

function toggleUserMenu() {
  userMenuOpen.value = !userMenuOpen.value
}

function closeUserMenu() {
  userMenuOpen.value = false
}

async function handleLogout() {
  closeUserMenu()
  await auth.logout()
}
</script>

<template>
  <div class="app-shell">
    <header class="app-navbar">
      <div class="navbar-inner">
        <RouterLink to="/" class="navbar-brand">
          <span class="brand-icon">W</span>
          <span class="brand-text">Wiki Loves</span>
        </RouterLink>
        <nav class="navbar-links">
          <RouterLink
            v-for="link in navLinks"
            :key="link.to"
            :to="link.to"
            class="navbar-link"
          >{{ link.label }}</RouterLink>
        </nav>
        <div class="navbar-actions">
          <RouterLink to="/about" class="navbar-link navbar-about">About</RouterLink>

          <!-- Auth -->
          <template v-if="auth.isLoggedIn">
            <div class="user-menu-wrap" @mouseleave="closeUserMenu">
              <button class="user-btn" @click="toggleUserMenu">
                <span class="user-avatar">{{ auth.user.username[0].toUpperCase() }}</span>
                <span class="user-name">{{ auth.user.username }}</span>
              </button>
              <div v-if="userMenuOpen" class="user-dropdown">
                <div class="dropdown-header">
                  Signed in as <strong>{{ auth.user.username }}</strong>
                </div>
                <RouterLink v-if="auth.isAdmin" to="/admin/campaigns" class="dropdown-item" @click="closeUserMenu">Manage Campaigns</RouterLink>
                <button class="dropdown-item dropdown-item--danger" @click="handleLogout">Sign out</button>
              </div>
            </div>
          </template>
          <button v-else class="login-btn" @click="auth.login()">
            <svg width="16" height="16" viewBox="0 0 20 20" fill="currentColor"><path d="M10 2a6 6 0 00-6 6c0 2.21 1.2 4.14 3 5.18V17a1 1 0 001 1h4a1 1 0 001-1v-3.82A6.002 6.002 0 0010 2z"/></svg>
            Sign in
          </button>
        </div>
      </div>
    </header>
    <main class="app-content">
      <RouterView />
    </main>
    <ToastContainer />
  </div>
</template>

<style scoped>
.app-shell {
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.app-navbar {
  position: sticky;
  top: 0;
  z-index: 100;
  background: var(--bg-primary);
  border-bottom: 1px solid var(--border-color);
  backdrop-filter: blur(12px);
  background: rgba(255,255,255,0.92);
}

:global(.dark) .app-navbar {
  background: rgba(15,23,42,0.92);
}

.navbar-inner {
  max-width: 1280px;
  margin: 0 auto;
  padding: 0 2rem;
  height: 56px;
  display: flex;
  align-items: center;
  gap: 2rem;
}

.navbar-brand {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  text-decoration: none;
  color: var(--text-primary);
  font-weight: 700;
  font-size: 1.125rem;
  flex-shrink: 0;
}

.navbar-brand:hover { text-decoration: none; }

.brand-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  background: var(--color-accent);
  color: #fff;
  font-weight: 800;
  font-size: 1rem;
  border-radius: 8px;
  font-family: Georgia, serif;
}

.brand-text {
  letter-spacing: -0.02em;
}

.navbar-links {
  display: flex;
  align-items: center;
  gap: 0.25rem;
  flex: 1;
  overflow-x: auto;
}

.navbar-link {
  padding: 0.375rem 0.75rem;
  border-radius: 6px;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--text-secondary);
  text-decoration: none;
  white-space: nowrap;
  transition: all 0.15s;
}

.navbar-link:hover {
  background: var(--bg-hover);
  color: var(--text-primary);
  text-decoration: none;
}

.navbar-link.router-link-active {
  background: var(--color-accent);
  color: #fff;
}

.navbar-actions {
  flex-shrink: 0;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.navbar-about {
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--text-secondary);
  padding: 0.375rem 0.75rem;
  border-radius: 6px;
}

/* Auth */
.login-btn {
  display: flex;
  align-items: center;
  gap: 0.375rem;
  padding: 0.375rem 0.875rem;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  background: var(--bg-card);
  color: var(--text-secondary);
  font-size: 0.8125rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.15s;
  white-space: nowrap;
}
.login-btn:hover { border-color: var(--color-accent); color: var(--color-accent); }

.user-menu-wrap { position: relative; }

.user-btn {
  display: flex;
  align-items: center;
  gap: 0.375rem;
  padding: 0.25rem 0.625rem 0.25rem 0.25rem;
  border: 1px solid var(--border-color);
  border-radius: 999px;
  background: var(--bg-card);
  cursor: pointer;
  transition: border-color 0.15s;
}
.user-btn:hover { border-color: var(--color-accent); }

.user-avatar {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 26px;
  height: 26px;
  border-radius: 50%;
  background: var(--color-accent);
  color: #fff;
  font-size: 0.75rem;
  font-weight: 700;
}

.user-name {
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--text-primary);
  max-width: 120px;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.user-dropdown {
  position: absolute;
  right: 0;
  top: calc(100% + 4px);
  width: 220px;
  background: var(--bg-card, #fff);
  border: 1px solid var(--border-color);
  border-radius: 8px;
  box-shadow: 0 8px 24px rgba(0,0,0,0.12);
  z-index: 200;
  overflow: hidden;
}

.dropdown-header {
  padding: 0.75rem 1rem;
  font-size: 0.8125rem;
  color: var(--text-secondary);
  border-bottom: 1px solid var(--border-color);
}

.dropdown-item {
  display: block;
  width: 100%;
  padding: 0.625rem 1rem;
  font-size: 0.875rem;
  font-weight: 500;
  color: var(--text-primary);
  text-decoration: none;
  background: none;
  border: none;
  text-align: left;
  cursor: pointer;
  transition: background 0.1s;
}
.dropdown-item:hover { background: var(--bg-hover, #f3f4f6); }
.dropdown-item--danger { color: #ef4444; }
.dropdown-item--danger:hover { background: #fef2f2; }

.app-content {
  flex: 1;
  background: var(--bg-page);
}

@media (max-width: 768px) {
  .navbar-inner {
    padding: 0 1rem;
    gap: 1rem;
  }

  .brand-text { display: none; }

  .navbar-links { gap: 0.125rem; }

  .navbar-link {
    padding: 0.25rem 0.5rem;
    font-size: 0.8125rem;
  }
}
</style>
