<script setup>
import { onMounted } from 'vue'
import { RouterView, RouterLink } from 'vue-router'
import ThemeToggle from '@/components/ThemeToggle.vue'
import ToastContainer from '@/components/ToastContainer.vue'
import { useThemeStore } from '@/stores/theme'
import { setupKeyboardNavigation } from '@/utils/accessibility'

const themeStore = useThemeStore()

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
  themeStore.applyTheme()
  setupKeyboardNavigation()
  window.addEventListener('toggleTheme', () => {
    themeStore.toggleTheme()
  })
})
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
          <ThemeToggle />
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
}

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
