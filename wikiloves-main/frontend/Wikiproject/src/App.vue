<script setup>
import { onMounted } from 'vue'
import { RouterView } from 'vue-router'
import ThemeToggle from '@/components/ThemeToggle.vue'
import ToastContainer from '@/components/ToastContainer.vue'
import { useThemeStore } from '@/stores/theme'
import { setupKeyboardNavigation } from '@/utils/accessibility'

const themeStore = useThemeStore()

onMounted(() => {
  themeStore.applyTheme()
  setupKeyboardNavigation()

  window.addEventListener('toggleTheme', () => {
    themeStore.toggleTheme()
  })
})
</script>

<template>
  <div class="wiki-shell">
    <main class="content-area">
      <div class="header-actions">
        <ThemeToggle />
      </div>
      <RouterView />
    </main>
    <ToastContainer />
  </div>
</template>

<style scoped>
.wiki-shell {
  display: flex;
  min-height: 100vh;
}

.content-area {
  flex: 1;
  min-height: 100vh;
  background: white;
}

.header-actions {
  position: fixed;
  top: 1rem;
  right: 1rem;
  z-index: 1000;
  display: flex;
  gap: 0.5rem;
}

@media (max-width: 900px) {
  .header-actions {
    top: 0.5rem;
    right: 0.5rem;
  }
}
</style>
