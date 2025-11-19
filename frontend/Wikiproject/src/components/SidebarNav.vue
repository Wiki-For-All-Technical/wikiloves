<script setup>
import { computed, onMounted } from 'vue'
import { useCatalogStore } from '@/stores/catalog'

const catalog = useCatalogStore()

onMounted(() => {
  if (!catalog.navigation.length) {
    catalog.loadNavigation()
  }
})

const navEntries = computed(() => catalog.navigation)
</script>

<template>
  <aside class="sidebar">
    <div class="sidebar__brand">
      <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Wiki_Loves_logo.svg/240px-Wiki_Loves_logo.svg.png" alt="Wiki Loves logo" />
    </div>
    <nav class="sidebar__nav">
      <template v-for="entry in navEntries" :key="entry.slug ?? entry.label">
        <RouterLink v-if="entry.type === 'home'" :to="entry.path" class="sidebar__link">
          {{ entry.label }}
        </RouterLink>
        <div v-else class="sidebar__section">
          <RouterLink :to="entry.path" class="sidebar__link sidebar__link--group">
            {{ entry.label }}
          </RouterLink>
          <ul>
            <li v-for="year in entry.years" :key="year">
              <RouterLink :to="`${entry.path}/${year}`">{{ year }}</RouterLink>
            </li>
          </ul>
        </div>
      </template>
    </nav>
  </aside>
</template>

<style scoped>
.sidebar {
  width: 220px;
  min-height: 100vh;
  border-right: 1px solid #d5dce3;
  padding: 1.5rem 1rem;
  background: #f7f9fc;
  font-size: 0.95rem;
}

.sidebar__brand {
  text-align: center;
  margin-bottom: 2rem;
}

.sidebar__brand img {
  max-width: 120px;
}

.sidebar__nav {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.sidebar__link {
  color: #0a3069;
  text-decoration: none;
  font-weight: 600;
}

.sidebar__link--group {
  display: block;
  margin-bottom: 0.25rem;
}

.sidebar__section ul {
  list-style: none;
  padding-left: 0.75rem;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.2rem;
}

.sidebar__section a {
  text-decoration: none;
  color: #1d4d8b;
  font-weight: 500;
}

.sidebar__section a.router-link-active {
  text-decoration: underline;
}

@media (max-width: 900px) {
  .sidebar {
    width: 100%;
    min-height: auto;
    border-right: none;
    border-bottom: 1px solid #d5dce3;
  }
}
</style>







