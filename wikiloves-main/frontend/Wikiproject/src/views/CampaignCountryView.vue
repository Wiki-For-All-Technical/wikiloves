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
const countryData = ref(null)

const segment = computed(() => route.params.segment)
const year = computed(() => parseInt(route.params.year))
const country = computed(() => route.params.country)

async function loadData() {
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
    
    const data = await catalog.loadCampaignCountryDetail(slug, year.value, country.value)
    countryData.value = data
  } catch (err) {
    console.error('Error loading country detail:', err)
    error.value = err.message || 'Failed to load data'
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadData()
})

watch(
  () => [route.params.segment, route.params.year, route.params.country],
  () => loadData(),
  { immediate: false }
)

function formatNum(num) {
  return new Intl.NumberFormat('en-US').format(num)
}

function formatDate(dateStr) {
  const date = new Date(dateStr)
  return date.toLocaleDateString('en-US', { year: 'numeric', month: 'short', day: 'numeric' })
}

function getDailyUploadUrl(date, categoryName) {
  return `https://heritage.toolforge.org/tools/daily-uploads/daily-uploads.html?date=${date}&category=${encodeURIComponent(categoryName)}&load=true`
}

function getCommonsUrl(categoryName) {
  return `https://commons.wikimedia.org/wiki/Category:${categoryName}`
}
</script>

<template>
  <div class="campaign-country-view">
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
    
    <div v-else-if="countryData" class="content">
      <header class="page-header">
        <h1>{{ countryData.campaign }} {{ countryData.year }} in {{ countryData.country }}</h1>
        <p class="subtitle">Tool Labs – Tools for Wiki Loves Photo Competitions</p>
        <p class="commons-link">
          <a :href="getCommonsUrl(countryData.category_name)">
            Category on Wikimedia Commons
          </a>
        </p>
        <p class="note">(All times are UTC.)</p>
      </header>

      <!-- Summary Stats -->
      <section class="summary-section">
        <div class="summary-card">
          <div class="summary-label">Total Images</div>
          <div class="summary-value">{{ formatNum(countryData.total_uploads) }}</div>
        </div>
        <div class="summary-card">
          <div class="summary-label">Total Uploaders</div>
          <div class="summary-value">{{ formatNum(countryData.total_uploaders) }}</div>
        </div>
        <div class="summary-card">
          <div class="summary-label">Images Used</div>
          <div class="summary-value">{{ formatNum(countryData.total_images_used) }}</div>
        </div>
        <div class="summary-card">
          <div class="summary-label">New Uploaders</div>
          <div class="summary-value">
            {{ formatNum(countryData.total_new_uploaders) }} 
            <span class="percentage">({{ Math.round((countryData.total_new_uploaders / countryData.total_uploaders * 100) || 0) }}%)</span>
          </div>
        </div>
      </section>

      <!-- Daily Statistics Table -->
      <section class="table-section">
        <div class="table-wrapper">
          <table>
            <thead>
              <tr>
                <th>Date</th>
                <th class="num-col">Images</th>
                <th class="num-col">Joiners</th>
                <th class="num-col">Joiners registered after competition start</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="day in countryData.daily_stats" :key="day.date">
                <td class="date-col">
                  <a 
                    :href="getDailyUploadUrl(day.date, countryData.category_name)" 
                    class="date-link"
                  >
                    {{ day.date }}
                  </a>
                </td>
                <td class="num-col">{{ formatNum(day.uploads) }}</td>
                <td class="num-col">{{ formatNum(day.uploaders) }}</td>
                <td class="num-col">
                  {{ formatNum(day.new_uploaders) }} 
                  <span class="percentage">({{ day.new_uploaders_pct }}%)</span>
                </td>
              </tr>
              <!-- Total Row -->
              <tr class="total-row">
                <td class="date-col"><strong>Total</strong></td>
                <td class="num-col"><strong>{{ formatNum(countryData.total_uploads) }}</strong></td>
                <td class="num-col"><strong>{{ formatNum(countryData.total_uploaders) }}</strong></td>
                <td class="num-col">
                  <strong>{{ formatNum(countryData.total_new_uploaders) }}</strong>
                  <span class="percentage">({{ Math.round((countryData.total_new_uploaders / countryData.total_uploaders * 100) || 0) }}%)</span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>

      <!-- Footer -->
      <footer class="page-footer">
        <p>Made with Flask</p>
        <p>The source of this tool is available under <a href="https://www.gnu.org/licenses/gpl-3.0.html" target="_blank">GNU General Public License 3.0 (GPL V3)</a>.</p>
      </footer>
    </div>
  </div>
</template>

<style scoped>
.campaign-country-view {
  padding: 2rem;
  max-width: 1400px;
  margin: 0 auto;
  color: var(--text-primary, #111827);
}

.page-header {
  margin-bottom: 2rem;
  text-align: center;
}

.page-header h1 {
  font-size: 2rem;
  font-weight: 700;
  margin-bottom: 0.5rem;
  color: var(--text-primary, #111827);
}

.subtitle {
  color: var(--text-secondary, #6b7280);
  font-size: 0.95rem;
  margin: 0.5rem 0;
}

.commons-link {
  margin: 0.75rem 0;
}

.commons-link a {
  color: #2563eb;
  text-decoration: none;
  font-weight: 500;
}

.commons-link a:hover {
  text-decoration: underline;
}

.note {
  color: var(--text-secondary, #6b7280);
  font-size: 0.875rem;
  font-style: italic;
  margin-top: 0.5rem;
}

.summary-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.summary-card {
  background: linear-gradient(135deg, var(--bg-card, #ffffff) 0%, var(--bg-secondary, #f9fafb) 100%);
  padding: 1.5rem;
  border-radius: 10px;
  border: 2px solid var(--border-color, #e5e7eb);
  text-align: center;
  transition: all 0.3s ease;
}

.summary-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 6px 16px rgba(0, 0, 0, 0.1);
  border-color: #2563eb;
}

.summary-label {
  font-size: 0.875rem;
  color: var(--text-secondary, #6b7280);
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  margin-bottom: 0.75rem;
}

.summary-value {
  font-size: 2rem;
  font-weight: 800;
  color: #2563eb;
  line-height: 1;
}

.table-section {
  background: var(--bg-card, #ffffff);
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  border: 1px solid var(--border-color, #e5e7eb);
  margin-bottom: 2rem;
}

.table-wrapper {
  overflow-x: auto;
  border-radius: 8px;
  border: 1px solid var(--border-color, #e5e7eb);
}

table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  font-size: 0.9375rem;
}

thead {
  position: sticky;
  top: 0;
  z-index: 10;
}

th {
  text-align: left;
  padding: 1rem;
  background: linear-gradient(135deg, var(--bg-secondary, #f9fafb) 0%, var(--bg-hover, #f3f4f6) 100%);
  color: var(--text-secondary, #374151);
  font-weight: 700;
  font-size: 0.8125rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  border-bottom: 2px solid var(--border-color, #e5e7eb);
  white-space: nowrap;
}

th:first-child {
  border-top-left-radius: 8px;
}

th:last-child {
  border-top-right-radius: 8px;
}

td {
  padding: 0.875rem 1rem;
  border-bottom: 1px solid var(--border-color, #f3f4f6);
  color: var(--text-primary, #1f2937);
}

tbody tr {
  transition: all 0.2s ease;
}

tbody tr:nth-child(even) {
  background-color: var(--bg-secondary, #f9fafb);
}

tbody tr:hover:not(.total-row) {
  background-color: var(--bg-hover, #f3f4f6);
  transform: scale(1.005);
}

.total-row {
  background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%) !important;
  border-top: 2px solid #2563eb;
  font-weight: 700;
}

.total-row td {
  padding: 1.125rem 1rem;
  color: #1e40af;
}

.date-col {
  font-weight: 500;
  min-width: 120px;
}

.date-link {
  color: #2563eb;
  text-decoration: none;
  font-weight: 600;
  transition: all 0.2s ease;
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
}

.date-link::after {
  content: '↗';
  opacity: 0;
  transform: translateX(-4px);
  transition: all 0.2s ease;
  font-size: 0.875rem;
}

.date-link:hover {
  color: #1d4ed8;
  text-decoration: underline;
}

.date-link:hover::after {
  opacity: 1;
  transform: translateX(0);
}

.num-col {
  text-align: right;
  font-variant-numeric: tabular-nums;
  font-weight: 600;
}

.percentage {
  color: var(--text-secondary, #6b7280);
  font-weight: 400;
  font-size: 0.875rem;
}

.page-footer {
  text-align: center;
  padding: 2rem 0;
  color: var(--text-secondary, #6b7280);
  font-size: 0.875rem;
  border-top: 1px solid var(--border-color, #e5e7eb);
}

.page-footer p {
  margin: 0.25rem 0;
}

.page-footer a {
  color: #2563eb;
  text-decoration: none;
}

.page-footer a:hover {
  text-decoration: underline;
}

.loading-state {
  text-align: center;
  padding: 4rem 2rem;
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
  margin-bottom: 1rem;
}

.back-btn {
  margin-top: 1.5rem;
  padding: 0.75rem 1.5rem;
  background: #dc2626;
  color: white;
  border: none;
  border-radius: 8px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.back-btn:hover {
  background: #b91c1c;
  transform: translateY(-2px);
  box-shadow: 0 4px 12px rgba(220, 38, 38, 0.3);
}

@media (max-width: 768px) {
  .campaign-country-view {
    padding: 1rem;
  }
  
  .page-header h1 {
    font-size: 1.5rem;
  }
  
  .summary-section {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
  
  .table-section {
    padding: 1rem;
  }
  
  th, td {
    padding: 0.75rem 0.5rem;
    font-size: 0.875rem;
  }
}
</style>

