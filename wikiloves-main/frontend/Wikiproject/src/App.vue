<script setup>
import { onMounted, computed } from 'vue'
import { RouterView, useRoute } from 'vue-router'
import ThemeToggle from '@/components/ThemeToggle.vue'
import ToastContainer from '@/components/ToastContainer.vue'
import SidebarNavigation from '@/components/SidebarNavigation.vue'
import { useThemeStore } from '@/stores/theme'
import { setupKeyboardNavigation } from '@/utils/accessibility'

const themeStore = useThemeStore()
const route = useRoute()

const isHome = computed(() => route.path === '/')
const standalonePaths = ['/', '/science', '/folklore', '/africa', '/food', '/public_art', '/earth', '/monuments']
const isCampaignYearPath = computed(() => {
  const p = route.path
  const campaignBases = ['/science', '/folklore', '/africa', '/food', '/public_art', '/earth', '/monuments']
  for (const base of campaignBases) {
    if (p.startsWith(base + '/') && /^\d+$/.test(p.slice(base.length + 1))) return true
  }
  return false
})
const isStandalonePage = computed(() => standalonePaths.includes(route.path) || isCampaignYearPath.value)

onMounted(() => {
  themeStore.applyTheme()
  setupKeyboardNavigation()
  
  // Listen for theme toggle keyboard shortcut
  window.addEventListener('toggleTheme', () => {
    themeStore.toggleTheme()
  })
})
</script>

<template>
  <div class="wiki-shell">
    <SidebarNavigation v-if="!isStandalonePage" />
    <main class="content-area" :class="{ 'content-area--full': isStandalonePage }">
      <div v-if="!isStandalonePage" class="header-actions">
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
  margin-left: 220px;
  min-height: 100vh;
  background: white;
}

.content-area--full {
  margin-left: 0;
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
  .content-area {
    margin-left: 0;
  }
  
  .header-actions {
    top: 0.5rem;
    right: 0.5rem;
  }
}
</style>
