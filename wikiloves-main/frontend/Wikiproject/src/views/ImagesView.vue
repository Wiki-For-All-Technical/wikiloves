<script setup>
import { computed, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useCatalogStore } from '@/stores/catalog'
import Breadcrumbs from '@/components/Breadcrumbs.vue'
import SkeletonLoader from '@/components/SkeletonLoader.vue'

const route = useRoute()
const router = useRouter()
const catalog = useCatalogStore()

const loading = ref(false)
const error = ref(null)
const images = ref([])

const event = computed(() => route.query.event)
const year = computed(() => route.query.year ? parseInt(route.query.year) : null)
const country = computed(() => route.query.country)
const user = computed(() => route.query.user)

const pageTitle = computed(() => {
  let title = 'Images'
  if (event.value && year.value && country.value) {
    title = `Images of Wiki Loves ${getCampaignName(event.value)} ${year.value}`
    if (country.value) {
      title += ` in ${country.value}`
    }
    if (user.value) {
      title += ` by ${user.value}`
    }
  }
  return title
})

function getCampaignName(slug) {
  const campaign = catalog.competitions.find(c => c.slug === slug)
  return campaign ? campaign.name : slug
}

async function loadImages() {
  loading.value = true
  error.value = null
  
  try {
    // Ensure navigation is loaded
    if (!catalog.navigation.length) {
      await catalog.loadNavigation()
    }
    
    // For now, we'll generate a placeholder structure
    // In a real implementation, this would fetch from an API
    // The images would come from Wikimedia Commons API or similar
    images.value = []
    
    // TODO: Implement actual image fetching from API
    // This would typically involve:
    // 1. Query Wikimedia Commons API for images in the category
    // 2. Format the response into image objects with thumbnails and metadata
    // 3. Display in a grid layout
    
  } catch (err) {
    console.error('Error loading images:', err)
    error.value = err.message || 'Failed to load images'
  } finally {
    loading.value = false
  }
}

function getCommonsCategoryUrl() {
  if (!event.value || !year.value || !country.value) return ''
  const campaignName = getCampaignName(event.value).replace(/\s+/g, '_')
  const countryName = country.value.replace(/\s+/g, '_')
  return `https://commons.wikimedia.org/wiki/Category:Images_from_Wiki_Loves_${campaignName}_${year.value}_in_${countryName}`
}

function getBackUrl() {
  if (event.value && year.value && country.value) {
    const segment = catalog.navigation.find(n => n.slug === event.value)?.path_segment || event.value
    return `/${segment}/${year.value}/${country.value}`
  }
  return '/'
}

onMounted(() => {
  loadImages()
})

// Watch for query parameter changes
watch(
  () => [route.query.event, route.query.year, route.query.country, route.query.user],
  () => loadImages(),
  { immediate: false }
)
</script>

<template>
  <div class="images-view">
    <Breadcrumbs />
    
    <div v-if="loading" class="loading-state">
      <SkeletonLoader type="card" height="200px" />
      <div class="skeleton-grid">
        <SkeletonLoader v-for="i in 8" :key="i" type="card" height="200px" />
      </div>
    </div>
    
    <div v-else-if="error" class="error-state">
      <h2>Error loading images</h2>
      <p>{{ error }}</p>
      <button @click="$router.back()" class="back-btn">← Go Back</button>
    </div>
    
    <div v-else class="content">
      <header class="page-header">
        <h1>{{ pageTitle }}</h1>
        <p class="subtitle">Tool Labs – Tools for Wiki Loves Photo Competitions</p>
        <div class="header-links">
          <router-link :to="getBackUrl()" class="back-link">
            Back to {{ event && year && country ? `${getCampaignName(event)} ${year} in ${country}` : 'Campaign' }}
          </router-link>
          <a v-if="getCommonsCategoryUrl()" :href="getCommonsCategoryUrl()" target="_blank" class="commons-link">
            Category on Wikimedia Commons
          </a>
        </div>
      </header>

      <!-- Images Grid -->
      <section class="images-section" v-if="images.length > 0">
        <div class="images-grid">
          <div
            v-for="(image, index) in images"
            :key="index"
            class="image-card"
          >
            <img :src="image.thumbnail" :alt="image.title" class="image-thumbnail" />
            <div class="image-info">
              <a :href="image.url" target="_blank" class="image-title">{{ image.title }}</a>
            </div>
          </div>
        </div>
      </section>
      
      <!-- Placeholder message -->
      <section v-else class="no-images-section">
        <p class="no-images-message">
          Image display functionality is being implemented.
        </p>
        <p class="no-images-subtitle">
          Images would be fetched from Wikimedia Commons API and displayed here in a grid layout.
        </p>
        <p v-if="getCommonsCategoryUrl()" class="commons-link-message">
          <a :href="getCommonsCategoryUrl()" target="_blank" class="commons-link-button">
            View images on Wikimedia Commons →
          </a>
        </p>
      </section>
    </div>
  </div>
</template>

<style scoped>
.images-view {
  padding: 2.5rem;
  max-width: 1400px;
  margin: 0 auto;
  animation: fadeIn 0.5s ease-in;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(10px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.page-header {
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 2px solid var(--border-color, #e5e7eb);
}

.page-header h1 {
  margin: 0 0 0.5rem 0;
  font-size: 2rem;
  font-weight: 700;
  color: var(--text-primary, #111827);
}

.subtitle {
  margin: 0 0 1rem 0;
  color: var(--text-secondary, #6b7280);
  font-size: 0.9375rem;
}

.header-links {
  display: flex;
  gap: 1.5rem;
  flex-wrap: wrap;
}

.back-link,
.commons-link {
  color: #2563eb;
  text-decoration: none;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  transition: all 0.2s ease;
  display: inline-block;
}

.back-link:hover,
.commons-link:hover {
  background-color: #eff6ff;
  color: #1d4ed8;
}

.images-section {
  margin-top: 2rem;
}

.images-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1.5rem;
}

.image-card {
  background: var(--bg-card, #ffffff);
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  transition: all 0.3s ease;
  border: 1px solid var(--border-color, #e5e7eb);
}

.image-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.15);
}

.image-thumbnail {
  width: 100%;
  height: 200px;
  object-fit: cover;
  display: block;
}

.image-info {
  padding: 1rem;
}

.image-title {
  color: var(--text-primary, #111827);
  text-decoration: none;
  font-size: 0.875rem;
  font-weight: 500;
  display: block;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.image-title:hover {
  color: #2563eb;
  text-decoration: underline;
}

.no-images-section {
  text-align: center;
  padding: 4rem 2rem;
  background: var(--bg-secondary, #f9fafb);
  border-radius: 12px;
  border: 2px dashed var(--border-color, #d1d5db);
}

.no-images-message {
  font-size: 1.125rem;
  color: var(--text-primary, #111827);
  margin: 0 0 0.5rem 0;
  font-weight: 500;
}

.no-images-subtitle {
  font-size: 0.9375rem;
  color: var(--text-secondary, #6b7280);
  margin: 0 0 1.5rem 0;
}

.commons-link-message {
  margin: 1.5rem 0 0 0;
}

.commons-link-button {
  display: inline-block;
  padding: 0.75rem 1.5rem;
  background: #2563eb;
  color: white;
  text-decoration: none;
  border-radius: 6px;
  font-weight: 600;
  transition: all 0.2s ease;
}

.commons-link-button:hover {
  background: #1d4ed8;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(37, 99, 235, 0.3);
}

.loading-state {
  padding: 2rem 0;
}

.skeleton-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-top: 1.5rem;
}

.error-state {
  text-align: center;
  padding: 4rem 2rem;
  background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
  border-radius: 12px;
  border: 1px solid #fecaca;
  color: #991b1b;
}

.error-state h2 {
  color: #dc2626;
  font-size: 1.75rem;
  margin-bottom: 1rem;
}

.back-btn {
  margin-top: 1.5rem;
  padding: 0.75rem 1.5rem;
  background: #dc2626;
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.back-btn:hover {
  background: #b91c1c;
  transform: translateY(-2px);
}

@media (max-width: 768px) {
  .images-view {
    padding: 1.5rem;
  }
  
  .images-grid {
    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
    gap: 1rem;
  }
  
  .page-header h1 {
    font-size: 1.5rem;
  }
}
</style>

