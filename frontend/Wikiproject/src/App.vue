<script setup>
import { onMounted } from 'vue'
import { RouterView } from 'vue-router'
import SidebarNav from '@/components/SidebarNav.vue'
import { useCatalogStore } from '@/stores/catalog'

const catalog = useCatalogStore()

onMounted(() => {
  if (!catalog.navigation.length) {
    catalog.loadNavigation()
  }
})
</script>

<template>
  <div class="wiki-shell">
    <SidebarNav />
    <main class="content-area">
      <RouterView />
    </main>
  </div>
</template>
