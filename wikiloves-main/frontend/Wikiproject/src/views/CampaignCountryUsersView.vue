<script setup>
import { computed, onMounted, watch, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useCatalogStore } from '@/stores/catalog'
import Breadcrumbs from '@/components/Breadcrumbs.vue'
import SkeletonLoader from '@/components/SkeletonLoader.vue'

const route = useRoute()
const router = useRouter()
const catalog = useCatalogStore()

const loading = ref(false)
const error = ref(null)
const uploaders = ref([])

const segment = computed(() => route.params.segment)
const year = computed(() => parseInt(route.params.year))
const country = computed(() => route.params.country)

const queryInfo = ref(null)
const showQueryInstructions = ref(false)

async function loadUploaders() {
  loading.value = true
  error.value = null
  
  try {
    // Ensure navigation is loaded
    if (!catalog.navigation.length) {
      await catalog.loadNavigation()
    }
    
    const slug = catalog.resolveSegment(segment.value)
    if (!slug) {
      error.value = 'Campaign not found'
      return
    }
    
    // Try to fetch uploader data from API
    try {
      const encodedCountry = encodeURIComponent(country.value)
      const response = await fetch(
        `http://127.0.0.1:5000/api/campaigns/${slug}/${year.value}/${encodedCountry}/users`
      )
      
      if (response.ok) {
        const data = await response.json()
        
        // Check if we have actual uploader data
        if (data.has_data && data.uploaders && Array.isArray(data.uploaders)) {
          uploaders.value = data.uploaders
          showQueryInstructions.value = false
        } else if (data.query) {
          // We got query instructions instead of data
          queryInfo.value = data
          showQueryInstructions.value = true
        } else {
          // No data available, show query instructions
          queryInfo.value = data
          showQueryInstructions.value = true
        }
      } else {
        // If endpoint returns 404 or error, show query instructions
        const errorData = await response.json().catch(() => ({}))
        if (errorData.query) {
          queryInfo.value = errorData
          showQueryInstructions.value = true
        } else {
          error.value = errorData.error || 'Failed to load uploader data'
        }
      }
    } catch (apiError) {
      console.error('Error fetching uploader data:', apiError)
      error.value = 'Failed to connect to API'
    }
    
  } catch (err) {
    console.error('Error loading uploaders:', err)
    error.value = err.message || 'Failed to load uploaders'
  } finally {
    loading.value = false
  }
}

function formatNum(num) {
  return new Intl.NumberFormat('en-US').format(num)
}

function getCommonsUserUrl(username) {
  return `https://commons.wikimedia.org/w/index.php?title=Special:ListFiles&limit=250&user=${encodeURIComponent(username)}`
}

function getImagesUrl(username) {
  const slug = catalog.resolveSegment(segment.value)
  if (!slug) return '#'
  return `/images?event=${slug}&year=${year.value}&country=${encodeURIComponent(country.value)}&user=${encodeURIComponent(username)}`
}

function getBackUrl() {
  return `/${segment.value}/${year.value}/${country.value}`
}

const campaignName = computed(() => {
  const slug = catalog.resolveSegment(segment.value)
  if (!slug) return segment.value
  const campaign = catalog.competitions.find(c => c.slug === slug)
  return campaign ? campaign.name : slug
})

const campaignSlug = computed(() => {
  return catalog.resolveSegment(segment.value) || segment.value
})

function copyQuery() {
  if (queryInfo.value && queryInfo.value.query) {
    navigator.clipboard.writeText(queryInfo.value.query).then(() => {
      alert('Query copied to clipboard!')
    }).catch(err => {
      console.error('Failed to copy query:', err)
    })
  }
}

function copySpecificQuery() {
  if (queryInfo.value && queryInfo.value.specific_query) {
    navigator.clipboard.writeText(queryInfo.value.specific_query).then(() => {
      alert('Specific query copied to clipboard!')
    }).catch(err => {
      console.error('Failed to copy query:', err)
    })
  }
}

onMounted(() => {
  loadUploaders()
})

watch(
  () => [route.params.segment, route.params.year, route.params.country],
  () => loadUploaders(),
  { immediate: false }
)
</script>

<template>
  <div class="campaign-country-users-view">
    <Breadcrumbs />
    
    <div v-if="loading" class="loading-state">
      <SkeletonLoader type="card" height="200px" />
      <SkeletonLoader type="table" :lines="10" />
    </div>
    
    <div v-else-if="error" class="error-state">
      <h2>Error loading data</h2>
      <p>{{ error }}</p>
      <button @click="$router.back()" class="back-btn">← Go Back</button>
    </div>
    
    <div v-else class="content">
      <header class="page-header">
        <h1>Wiki Loves {{ campaignName }} {{ year }} in {{ country }}</h1>
        <p class="subtitle">Tool Labs – Tools for Wiki Loves Photo Competitions</p>
        <div class="header-links">
          <router-link :to="getBackUrl()" class="back-link">
            Back to {{ campaignName }} {{ year }} in {{ country }}
          </router-link>
        </div>
      </header>

      <!-- Query Instructions (if data not available) -->
      <section v-if="showQueryInstructions && queryInfo" class="query-instructions-section">
        <div class="instructions-card">
          <h2>Get Uploader Data from Quarry</h2>
          <div v-if="queryInfo.query_type === 'comprehensive'" class="comprehensive-query-badge">
            <strong>💡 Comprehensive Query:</strong> This query fetches uploader data for <strong>ALL years and ALL countries</strong> for this campaign in one go. 
            After processing, data will be available for all year/country combinations automatically.
          </div>
          <p class="instructions-intro">
            To display uploader statistics, you need to run a query on <a href="https://quarry.wmcloud.org/" target="_blank">Quarry</a> 
            and download the results. Follow these steps:
          </p>
          
          <ol class="instructions-steps">
            <li v-for="(instruction, key) in queryInfo.instructions" :key="key">
              <template v-if="key !== 'note'">
                <strong>{{ key.replace('step', 'Step ') }}:</strong> {{ instruction }}
              </template>
            </li>
            <li v-if="queryInfo.instructions.note" class="note-step">
              <strong>💡 Note:</strong> {{ queryInfo.instructions.note }}
            </li>
          </ol>
          
          <div class="query-box">
            <div class="query-header">
              <h3>{{ queryInfo.query_type === 'comprehensive' ? 'Comprehensive SQL Query (All Years & Countries)' : 'SQL Query' }}</h3>
              <button @click="copyQuery" class="copy-btn">Copy Query</button>
            </div>
            <pre class="query-code"><code>{{ queryInfo.query }}</code></pre>
          </div>
          
          <div v-if="queryInfo.specific_query" class="alternative-query-section">
            <details class="alternative-query-details">
              <summary>Alternative: Query for this specific year/country only</summary>
              <div class="query-box" style="margin-top: 1rem;">
                <div class="query-header">
                  <h3>Specific Query ({{ year }} / {{ country }} only)</h3>
                  <button @click="copySpecificQuery" class="copy-btn">Copy Query</button>
                </div>
                <pre class="query-code"><code>{{ queryInfo.specific_query }}</code></pre>
              </div>
            </details>
          </div>
          
          <div class="quarry-link-box">
            <a :href="queryInfo.quarry_url" target="_blank" class="quarry-link-button">
              Open Quarry →
            </a>
            <p class="quarry-note">
              Database: <strong>{{ queryInfo.database }}</strong>
            </p>
          </div>
        </div>
      </section>

      <!-- Uploaders Table -->
      <section class="table-section" v-if="!showQueryInstructions || uploaders.length > 0">
        <div class="table-wrapper">
          <table class="uploaders-table">
            <thead>
              <tr>
                <th class="uploader-col">Uploader</th>
                <th class="images-col">Images</th>
                <th class="images-used-col">Images used in the wikis</th>
                <th class="registration-col">Registration</th>
              </tr>
            </thead>
            <tbody>
              <tr v-if="uploaders.length === 0 && !showQueryInstructions" class="no-data-row">
                <td colspan="4" class="no-data-message">
                  <p>No uploader data available.</p>
                  <p class="no-data-subtitle">
                    Use the query instructions above to fetch data from Quarry.
                  </p>
                </td>
              </tr>
              <tr v-for="uploader in uploaders" :key="uploader.username">
                <td class="uploader-col">
                  <a :href="getCommonsUserUrl(uploader.username)" target="_blank" class="username-link">
                    {{ uploader.username }}
                  </a>
                </td>
                <td class="images-col">
                  <a :href="getImagesUrl(uploader.username)" class="images-link">
                    {{ formatNum(uploader.images) }}
                  </a>
                </td>
                <td class="images-used-col">
                  {{ formatNum(uploader.images_used) }}
                </td>
                <td class="registration-col">
                  {{ uploader.registration || uploader.registration_date }}
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </div>
  </div>
</template>

<style scoped>
.campaign-country-users-view {
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

.back-link {
  color: #2563eb;
  text-decoration: none;
  font-weight: 500;
  padding: 0.5rem 1rem;
  border-radius: 6px;
  transition: all 0.2s ease;
  display: inline-block;
}

.back-link:hover {
  background-color: #eff6ff;
  color: #1d4ed8;
}

.table-section {
  margin-top: 2rem;
}

.table-wrapper {
  overflow-x: auto;
  border-radius: 8px;
  border: 1px solid var(--border-color, #e5e7eb);
  background: var(--bg-primary, #fff);
}

.uploaders-table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  font-size: 0.9375rem;
}

.uploaders-table thead {
  position: sticky;
  top: 0;
  z-index: 10;
}

.uploaders-table th {
  text-align: left;
  padding: 1.25rem 1rem;
  background: linear-gradient(135deg, var(--bg-secondary, #f9fafb) 0%, var(--bg-hover, #f3f4f6) 100%);
  color: var(--text-secondary, #374151);
  font-weight: 700;
  font-size: 0.8125rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  border-bottom: 2px solid var(--border-color, #e5e7eb);
  white-space: nowrap;
}

.uploaders-table th:first-child {
  border-top-left-radius: 8px;
}

.uploaders-table th:last-child {
  border-top-right-radius: 8px;
}

.uploaders-table td {
  padding: 1.125rem 1rem;
  border-bottom: 1px solid var(--border-color, #f3f4f6);
  transition: all 0.2s ease;
  color: var(--text-primary, #1f2937);
}

.uploaders-table tbody tr {
  transition: all 0.2s ease;
}

.uploaders-table tbody tr:nth-child(even) {
  background-color: var(--bg-secondary, #f9fafb);
}

.uploaders-table tbody tr:hover {
  background-color: var(--bg-hover, #f3f4f6);
}

.uploaders-table tbody tr:last-child td {
  border-bottom: none;
}

.uploaders-table tbody tr:last-child td:first-child {
  border-bottom-left-radius: 8px;
}

.uploaders-table tbody tr:last-child td:last-child {
  border-bottom-right-radius: 8px;
}

.uploader-col {
  font-weight: 600;
}

.username-link {
  color: #2563eb;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.2s ease;
}

.username-link:hover {
  color: #1d4ed8;
  text-decoration: underline;
}

.images-col {
  text-align: right;
  font-variant-numeric: tabular-nums;
  font-weight: 600;
}

.images-link {
  color: #059669;
  text-decoration: none;
  font-weight: 600;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  transition: all 0.2s ease;
  display: inline-block;
}

.images-link:hover {
  background-color: #ecfdf5;
  color: #047857;
}

.images-used-col {
  text-align: right;
  font-variant-numeric: tabular-nums;
  font-weight: 600;
  color: var(--text-primary, #1f2937);
}

.registration-col {
  color: var(--text-secondary, #6b7280);
  font-size: 0.875rem;
}

.no-data-row {
  background-color: var(--bg-secondary, #f9fafb) !important;
}

.no-data-message {
  text-align: center;
  padding: 3rem 2rem;
  color: var(--text-secondary, #6b7280);
}

.no-data-message p {
  margin: 0.5rem 0;
}

.no-data-subtitle {
  font-size: 0.875rem;
  color: var(--text-secondary, #9ca3af);
  margin-top: 1rem !important;
}

.api-note {
  margin-top: 1.5rem !important;
  font-size: 0.8125rem;
  color: var(--text-secondary, #9ca3af);
  font-family: 'Courier New', monospace;
}

.api-note code {
  background: var(--bg-hover, #f3f4f6);
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-size: 0.75rem;
}

.loading-state {
  padding: 2rem 0;
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

.query-instructions-section {
  margin-top: 2rem;
}

.instructions-card {
  background: linear-gradient(135deg, #f0f9ff 0%, #e0f2fe 100%);
  padding: 2rem;
  border-radius: 12px;
  border: 2px solid #0ea5e9;
  box-shadow: 0 4px 6px rgba(14, 165, 233, 0.1);
}

.instructions-card h2 {
  margin: 0 0 1rem 0;
  color: #0c4a6e;
  font-size: 1.5rem;
}

.instructions-intro {
  margin: 0 0 1.5rem 0;
  color: #075985;
  line-height: 1.6;
}

.instructions-intro a {
  color: #0284c7;
  font-weight: 600;
  text-decoration: none;
}

.instructions-intro a:hover {
  text-decoration: underline;
}

.instructions-steps {
  margin: 0 0 2rem 0;
  padding-left: 1.5rem;
  color: #075985;
  line-height: 1.8;
}

.instructions-steps li {
  margin-bottom: 0.75rem;
}

.query-box {
  background: #ffffff;
  border: 1px solid #bae6fd;
  border-radius: 8px;
  margin: 1.5rem 0;
  overflow: hidden;
}

.query-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 1rem 1.5rem;
  background: #e0f2fe;
  border-bottom: 1px solid #bae6fd;
}

.query-header h3 {
  margin: 0;
  color: #0c4a6e;
  font-size: 1.125rem;
}

.copy-btn {
  padding: 0.5rem 1rem;
  background: #0284c7;
  color: white;
  border: none;
  border-radius: 6px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.copy-btn:hover {
  background: #0369a1;
  transform: translateY(-1px);
}

.query-code {
  margin: 0;
  padding: 1.5rem;
  overflow-x: auto;
  background: #f8fafc;
  font-family: 'Courier New', monospace;
  font-size: 0.875rem;
  line-height: 1.6;
  color: #1e293b;
}

.query-code code {
  white-space: pre;
}

.quarry-link-box {
  text-align: center;
  margin-top: 1.5rem;
}

.quarry-link-button {
  display: inline-block;
  padding: 1rem 2rem;
  background: #0ea5e9;
  color: white;
  text-decoration: none;
  border-radius: 8px;
  font-weight: 700;
  font-size: 1.125rem;
  transition: all 0.2s ease;
  box-shadow: 0 4px 6px rgba(14, 165, 233, 0.3);
}

.quarry-link-button:hover {
  background: #0284c7;
  transform: translateY(-2px);
  box-shadow: 0 6px 12px rgba(14, 165, 233, 0.4);
}

.quarry-note {
  margin: 1rem 0 0 0;
  color: #075985;
  font-size: 0.9375rem;
}

.comprehensive-query-badge {
  background: linear-gradient(135deg, #dbeafe 0%, #bfdbfe 100%);
  border: 2px solid #3b82f6;
  border-radius: 8px;
  padding: 1rem 1.5rem;
  margin-bottom: 1.5rem;
  color: #1e40af;
  line-height: 1.6;
}

.comprehensive-query-badge strong {
  color: #1e3a8a;
}

.note-step {
  background: #fef3c7;
  padding: 0.75rem 1rem;
  border-radius: 6px;
  border-left: 4px solid #f59e0b;
  margin-top: 0.5rem;
}

.alternative-query-section {
  margin-top: 1.5rem;
}

.alternative-query-details {
  background: #f9fafb;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  padding: 1rem;
}

.alternative-query-details summary {
  cursor: pointer;
  font-weight: 600;
  color: #374151;
  padding: 0.5rem;
  user-select: none;
}

.alternative-query-details summary:hover {
  color: #2563eb;
}

@media (max-width: 768px) {
  .campaign-country-users-view {
    padding: 1.5rem;
  }
  
  .uploaders-table {
    font-size: 0.875rem;
  }
  
  .uploaders-table th,
  .uploaders-table td {
    padding: 0.75rem 0.5rem;
  }
  
  .page-header h1 {
    font-size: 1.5rem;
  }
  
  .instructions-card {
    padding: 1.5rem;
  }
  
  .query-code {
    font-size: 0.75rem;
    padding: 1rem;
  }
}
</style>

