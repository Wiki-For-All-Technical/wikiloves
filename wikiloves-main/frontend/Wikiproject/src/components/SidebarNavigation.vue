<script setup>
import { ref, onMounted } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import axios from 'axios'

const router = useRouter()
const route = useRoute()

const navigation = ref([])
const loading = ref(true)
const expandedCampaigns = ref(new Set())

const toggleCampaign = (slug) => {
  if (expandedCampaigns.value.has(slug)) {
    expandedCampaigns.value.delete(slug)
  } else {
    expandedCampaigns.value.add(slug)
  }
}

const isExpanded = (slug) => {
  return expandedCampaigns.value.has(slug)
}

onMounted(async () => {
  try {
    // Try to fetch from backend API, fallback to static data
    try {
      const response = await axios.get('/api/navigation')
      navigation.value = response.data
    } catch (err) {
       // Fallback: use static navigation (Monuments and Food)
      navigation.value = [
        {
          type: 'home',
          label: 'Main page',
          slug: 'home',
          path: '/'
        },
        {
          type: 'competition',
          label: 'WL Monuments',
          slug: 'monuments',
          path_segment: 'monuments',
          years: [2025]
        },
        {
          type: 'competition',
          label: 'WL Food',
          slug: 'food',
          path_segment: 'food',
          years: [2025]
        },
        {
          type: 'link',
          label: 'WL Science',
          slug: 'science',
          path_segment: 'science',
          path: '/science'
        }
      ]
    }
    
    // If API returned multiple campaigns, keep only Main page, Monuments, Food, and Science
    if (navigation.value.length > 4) {
      const home = navigation.value.find(n => n.type === 'home')
      const monuments = navigation.value.find(n => n.slug === 'monuments' || n.path_segment === 'monuments')
      const food = navigation.value.find(n => n.slug === 'food' || n.path_segment === 'food')
      const science = navigation.value.find(n => n.slug === 'science' || n.path_segment === 'science')
      navigation.value = [
        home || { type: 'home', label: 'Main page', slug: 'home', path: '/' },
        monuments || { type: 'competition', label: 'WL Monuments', slug: 'monuments', path_segment: 'monuments', years: [2025] },
        food || { type: 'competition', label: 'WL Food', slug: 'food', path_segment: 'food', years: [2025] },
        science || { type: 'link', label: 'WL Science', slug: 'science', path_segment: 'science', path: '/science' }
      ]
    }
    
    // Ensure campaigns only have 2025
    const mon = navigation.value.find(n => n.slug === 'monuments' || n.path_segment === 'monuments')
    if (mon) {
      mon.years = [2025]
    }
    const food = navigation.value.find(n => n.slug === 'food' || n.path_segment === 'food')
    if (food) {
      food.years = [2025]
    }
    
    // Auto-expand campaigns (and current campaign if on a campaign page)
    expandedCampaigns.value.add('monuments')
    expandedCampaigns.value.add('food')
    const currentSegment = route.params.segment
    if (route.path === '/science') {
      expandedCampaigns.value.add('science')
    }
    if (currentSegment) {
      expandedCampaigns.value.add(currentSegment)
    }
    
    loading.value = false
  } catch (err) {
    console.error('Failed to load navigation:', err)
    loading.value = false
  }
})
</script>

<template>
  <aside class="sidebar">
    <div class="sidebar-content">
      <!-- Logo -->
      <div class="logo-container">
        <router-link to="/" class="logo-link">
          <svg class="logo" viewBox="0 0 100 100" xmlns="http://www.w3.org/2000/svg">
            <!-- Simplified Wiki Loves logo -->
            <circle cx="50" cy="50" r="45" fill="#1f8a70" />
            <circle cx="50" cy="50" r="35" fill="#c14953" />
            <circle cx="50" cy="50" r="25" fill="#3b82f6" />
            <text x="50" y="60" text-anchor="middle" fill="white" font-size="20" font-weight="bold">W</text>
          </svg>
        </router-link>
      </div>

      <!-- Navigation -->
      <nav class="nav-menu" v-if="!loading">
        <ul class="nav-list">
          <li v-for="item in navigation" :key="item.slug" class="nav-item">
            <template v-if="item.type === 'home'">
              <router-link
                :to="item.path"
                class="nav-link"
                :class="{ active: route.path === item.path }"
              >
                {{ item.label }}
              </router-link>
            </template>
            
            <template v-else-if="item.type === 'competition' && item.years && item.years.length > 0">
              <div class="nav-campaign">
                <button
                  class="nav-link nav-link-campaign"
                  :class="{ active: route.params.segment === item.path_segment }"
                  @click="toggleCampaign(item.slug)"
                >
                  <span>{{ item.label }}</span>
                  <span class="expand-icon" :class="{ expanded: isExpanded(item.slug) }">▼</span>
                </button>
                
                <ul
                  v-if="isExpanded(item.slug)"
                  class="nav-years"
                >
                  <li v-for="year in item.years" :key="year" class="nav-year-item">
                    <router-link
                      :to="item.path_segment === 'monuments' && year === 2025 ? '/monuments/2025/India' : '/comparison'"
                      class="nav-link nav-link-year"
                      :class="{ active: route.path === '/monuments/2025/India' || (route.params.segment === item.path_segment && route.params.year == year) }"
                    >
                      {{ year }}
                    </router-link>
                  </li>
                </ul>
              </div>
            </template>
            
            <template v-else>
              <router-link
                :to="item.path || '/comparison'"
                class="nav-link"
                :class="{ active: route.params.segment === item.path_segment || (item.path_segment === 'science' && route.path === '/science') }"
              >
                {{ item.label }}
              </router-link>
            </template>
          </li>
        </ul>
      </nav>
    </div>
  </aside>
</template>

<style scoped>
.sidebar {
  width: 220px;
  min-height: 100vh;
  background: #f9fafb;
  border-right: 1px solid #e5e7eb;
  position: fixed;
  left: 0;
  top: 0;
  overflow-y: auto;
  z-index: 100;
}

.sidebar-content {
  padding: 1.5rem 0;
}

.logo-container {
  padding: 0 1rem 1.5rem 1rem;
  border-bottom: 1px solid #e5e7eb;
  margin-bottom: 1rem;
}

.logo-link {
  display: block;
  text-decoration: none;
}

.logo {
  width: 60px;
  height: 60px;
  display: block;
}

.nav-menu {
  padding: 0;
}

.nav-list {
  list-style: none;
  margin: 0;
  padding: 0;
}

.nav-item {
  margin: 0;
}

.nav-link {
  display: block;
  padding: 0.625rem 1rem;
  color: #1f2937;
  text-decoration: none;
  font-size: 0.9375rem;
  transition: background-color 0.2s ease, color 0.2s ease;
  border-left: 3px solid transparent;
}

.nav-link:hover {
  background-color: #f3f4f6;
  color: #111827;
}

.nav-link.active {
  background-color: #eff6ff;
  color: #1e40af;
  border-left-color: #3b82f6;
  font-weight: 500;
}

.nav-link-campaign {
  display: flex;
  justify-content: space-between;
  align-items: center;
  width: 100%;
  background: none;
  border: none;
  text-align: left;
  cursor: pointer;
}

.expand-icon {
  font-size: 0.75rem;
  transition: transform 0.2s ease;
  color: #6b7280;
}

.expand-icon.expanded {
  transform: rotate(180deg);
}

.nav-years {
  list-style: none;
  margin: 0;
  padding: 0;
  background: white;
  border-left: 2px solid #e5e7eb;
  margin-left: 1rem;
}

.nav-year-item {
  margin: 0;
}

.nav-link-year {
  padding-left: 2rem;
  font-size: 0.875rem;
  color: #4b5563;
}

.nav-link-year:hover {
  background-color: #f9fafb;
  color: #1f2937;
}

.nav-link-year.active {
  background-color: #eff6ff;
  color: #1e40af;
  font-weight: 500;
}

@media (max-width: 900px) {
  .sidebar {
    transform: translateX(-100%);
    transition: transform 0.3s ease;
  }
  
  .sidebar.open {
    transform: translateX(0);
  }
}
</style>
