<script setup>
import { useThemeStore } from '@/stores/theme'
import { computed } from 'vue'

const themeStore = useThemeStore()

const toggleTheme = () => {
  themeStore.toggleTheme()
}

const isDark = computed(() => themeStore.isDark)
</script>

<template>
  <button
    @click="toggleTheme"
    class="theme-toggle"
    :aria-label="isDark ? 'Switch to light mode' : 'Switch to dark mode'"
    title="Toggle theme"
  >
    <span v-if="isDark" class="theme-icon">☀️</span>
    <span v-else class="theme-icon">🌙</span>
  </button>
</template>

<style scoped>
.theme-toggle {
  background: transparent;
  border: 2px solid currentColor;
  border-radius: 8px;
  padding: 0.5rem;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  color: var(--text-primary);
}

.theme-toggle:hover {
  background: var(--bg-hover);
  transform: scale(1.1);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
}

.theme-icon {
  font-size: 1.25rem;
  line-height: 1;
  transition: transform 0.3s ease;
}

.theme-toggle:hover .theme-icon {
  transform: rotate(15deg);
}
</style>

