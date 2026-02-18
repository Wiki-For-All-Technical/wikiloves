<script setup>
import { computed } from 'vue'
import { useRoute, RouterLink } from 'vue-router'

const route = useRoute()

const breadcrumbs = computed(() => {
  const paths = []
  const pathSegments = route.path.split('/').filter(Boolean)
  
  let currentPath = ''
  pathSegments.forEach((segment, index) => {
    currentPath += `/${segment}`
    const isLast = index === pathSegments.length - 1
    
    // Format segment name
    let name = segment
    if (segment === 'earth') name = 'Wiki Loves Earth'
    else if (segment === 'monuments') name = 'Wiki Loves Monuments'
    else if (segment === 'science') name = 'Wiki Science Competition'
    else if (segment === 'folklore') name = 'Wiki Loves Folklore'
    else if (segment === 'africa') name = 'Wiki Loves Africa'
    else if (segment === 'food') name = 'Wiki Loves Food'
    else if (segment === 'public_art') name = 'Wiki Loves Public Art'
    else if (!isNaN(segment)) name = `Year ${segment}`
    else name = segment.charAt(0).toUpperCase() + segment.slice(1).replace(/-/g, ' ')
    
    paths.push({
      name,
      path: currentPath,
      isLast
    })
  })
  
  return paths
})
</script>

<template>
  <nav v-if="breadcrumbs.length > 0" class="breadcrumbs" aria-label="Breadcrumb">
    <ol class="breadcrumb-list">
      <li>
        <RouterLink to="/" class="breadcrumb-link">Home</RouterLink>
      </li>
      <li v-for="crumb in breadcrumbs" :key="crumb.path" class="breadcrumb-item">
        <span class="breadcrumb-separator">/</span>
        <RouterLink
          v-if="!crumb.isLast"
          :to="crumb.path"
          class="breadcrumb-link"
        >
          {{ crumb.name }}
        </RouterLink>
        <span v-else class="breadcrumb-current">{{ crumb.name }}</span>
      </li>
    </ol>
  </nav>
</template>

<style scoped>
.breadcrumbs {
  margin-bottom: 1.5rem;
  padding: 0.75rem 0;
}

.breadcrumb-list {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 0.5rem;
  list-style: none;
  margin: 0;
  padding: 0;
  font-size: 0.9375rem;
}

.breadcrumb-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.breadcrumb-separator {
  color: var(--text-secondary, #6b7280);
  user-select: none;
}

.breadcrumb-link {
  color: var(--wiki-link, #2563eb);
  text-decoration: none;
  transition: color 0.2s ease;
  font-weight: 500;
}

.breadcrumb-link:hover {
  color: var(--accent-color, #1f8a70);
  text-decoration: underline;
}

.breadcrumb-current {
  color: var(--text-primary, #111827);
  font-weight: 600;
}

:global(.dark) .breadcrumb-current {
  color: var(--text-primary);
}
</style>

