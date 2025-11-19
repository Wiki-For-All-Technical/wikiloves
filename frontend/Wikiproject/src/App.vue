<script setup>
import { onMounted } from 'vue'
import { RouterView } from 'vue-router'
import SidebarNav from '@/components/SidebarNav.vue'
import ThemeToggle from '@/components/ThemeToggle.vue'
import ToastContainer from '@/components/ToastContainer.vue'
import { useCatalogStore } from '@/stores/catalog'
import { useThemeStore } from '@/stores/theme'
import { setupKeyboardNavigation } from '@/utils/accessibility'

const catalog = useCatalogStore()
const themeStore = useThemeStore()

onMounted(() => {
  themeStore.applyTheme()
  setupKeyboardNavigation()
  
  // Listen for theme toggle keyboard shortcut
  window.addEventListener('toggleTheme', () => {
    themeStore.toggleTheme()
  })
  
  if (!catalog.navigation.length) {
    catalog.loadNavigation()
  }
})
</script>

<template>
  <div class="wiki-shell">
    <SidebarNav />
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
