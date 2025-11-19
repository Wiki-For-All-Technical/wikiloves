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
  width: 260px;
  min-height: 100vh;
  border-right: 1px solid var(--border-color, #e5e7eb);
  padding: 2rem 1.5rem;
  background: linear-gradient(180deg, var(--bg-primary, #ffffff) 0%, var(--bg-secondary, #f9fafb) 100%);
  font-size: 0.9375rem;
  box-shadow: 2px 0 8px rgba(0, 0, 0, 0.04);
  position: sticky;
  top: 0;
  max-height: 100vh;
  overflow-y: auto;
  transition: background 0.3s ease, border-color 0.3s ease;
}

.sidebar::-webkit-scrollbar {
  width: 6px;
}

.sidebar::-webkit-scrollbar-track {
  background: transparent;
}

.sidebar::-webkit-scrollbar-thumb {
  background: #d1d5db;
  border-radius: 3px;
}

.sidebar::-webkit-scrollbar-thumb:hover {
  background: #9ca3af;
}

.sidebar__brand {
  text-align: center;
  margin-bottom: 2.5rem;
  padding-bottom: 1.5rem;
  border-bottom: 2px solid var(--border-color, #e5e7eb);
}

.sidebar__brand img {
  max-width: 140px;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
  transition: transform 0.3s ease;
}

.sidebar__brand:hover img {
  transform: scale(1.05);
}

.sidebar__nav {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.sidebar__link {
  color: var(--text-primary, #1f2937);
  text-decoration: none;
  font-weight: 700;
  font-size: 1rem;
  padding: 0.75rem 1rem;
  border-radius: 8px;
  transition: all 0.2s ease;
  display: block;
}

.sidebar__link:hover {
  background-color: var(--bg-hover, #f3f4f6);
  color: var(--text-primary, #111827);
  transform: translateX(4px);
}

.sidebar__link.router-link-active {
  background: linear-gradient(135deg, #1f8a70 0%, #1a6b57 100%);
  color: #ffffff;
  box-shadow: 0 2px 8px rgba(31, 138, 112, 0.3);
}

.sidebar__link--group {
  display: block;
  margin-bottom: 0.5rem;
}

.sidebar__section {
  margin-bottom: 0.5rem;
}

.sidebar__section ul {
  list-style: none;
  padding-left: 0;
  margin: 0.5rem 0 0 0;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.sidebar__section ul li {
  margin: 0;
}

.sidebar__section a {
  text-decoration: none;
  color: var(--text-secondary, #6b7280);
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  display: block;
  transition: all 0.2s ease;
  font-size: 0.9375rem;
  position: relative;
}

.sidebar__section a::before {
  content: '';
  position: absolute;
  left: 0;
  top: 50%;
  transform: translateY(-50%);
  width: 3px;
  height: 0;
  background: #1f8a70;
  border-radius: 0 2px 2px 0;
  transition: height 0.2s ease;
}

.sidebar__section a:hover {
  background-color: var(--bg-hover, #f3f4f6);
  color: var(--text-primary, #1f2937);
  padding-left: 1.25rem;
}

.sidebar__section a:hover::before {
  height: 60%;
}

.sidebar__section a.router-link-active {
  background: linear-gradient(90deg, rgba(31, 138, 112, 0.1) 0%, transparent 100%);
  color: #1f8a70;
  font-weight: 700;
  padding-left: 1.25rem;
}

.sidebar__section a.router-link-active::before {
  height: 100%;
  background: #1f8a70;
}

@media (max-width: 900px) {
  .sidebar {
    width: 100%;
    min-height: auto;
    border-right: none;
    border-bottom: 1px solid #e5e7eb;
    position: relative;
    max-height: none;
    padding: 1.5rem;
  }
  
  .sidebar__nav {
    gap: 1rem;
  }
}
</style>







