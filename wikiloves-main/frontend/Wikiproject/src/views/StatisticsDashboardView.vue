<script setup>
import { ref, computed, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import DailyUploadsChart from '../components/DailyUploadsChart.vue'
import UserContributionChart from '../components/UserContributionChart.vue'
import FileSizeSpectrumChart from '../components/FileSizeSpectrumChart.vue'
import {
  parseQuarryData,
  getDailyUploads,
  getUserContributions,
  getFileSizeDistribution,
  getOverallStats,
  formatFileSize
} from '../utils/quarryDataProcessor.js'

const route = useRoute()

const loading = ref(true)
const error = ref(null)
const rawData = ref(null)
const processedData = ref(null)

const dailyUploads = computed(() => {
  if (!processedData.value) return []
  return getDailyUploads(processedData.value)
})

const userContributions = computed(() => {
  if (!processedData.value) return []
  return getUserContributions(processedData.value)
})

const fileSizeDistribution = computed(() => {
  if (!processedData.value) return []
  return getFileSizeDistribution(processedData.value)
})

const overallStats = computed(() => {
  if (!processedData.value) return null
  return getOverallStats(processedData.value)
})

// Load data from URL query parameter or fetch from API
onMounted(async () => {
  try {
    let dataUrl = route.query.url || route.query.dataUrl
    
    if (!dataUrl) {
      error.value = 'No data URL provided. Add ?url=<quarry_json_url> to the URL.'
      loading.value = false
      return
    }

    // If it's a Quarry URL, use proxy
    if (dataUrl.includes('quarry.wmcloud.org')) {
      dataUrl = '/quarry' + new URL(dataUrl).pathname
    }

    const response = await fetch(dataUrl)
    if (!response.ok) {
      throw new Error(`Failed to fetch data: ${response.statusText}`)
    }

    const jsonData = await response.json()
    rawData.value = jsonData
    
    // Process the data
    processedData.value = parseQuarryData(jsonData)
    
    if (processedData.value.length === 0) {
      error.value = 'No data found in the response.'
    }
    
    loading.value = false
  } catch (err) {
    error.value = err.message || 'Failed to load statistics data'
    loading.value = false
  }
})

const countryName = computed(() => {
  if (!rawData.value || !rawData.value.rows || rawData.value.rows.length === 0) {
    return 'Unknown'
  }
  const firstRow = rawData.value.rows[0]
  const clToIndex = rawData.value.headers.indexOf('cl_to')
  if (clToIndex >= 0 && firstRow[clToIndex]) {
    const category = firstRow[clToIndex]
    const match = category.match(/Images_from_Wiki_Loves_Monuments_2025_in_(.+)/)
    if (match) {
      return match[1].replace(/_/g, ' ')
    }
  }
  return 'Unknown'
})
</script>

<template>
  <div class="statistics-dashboard">
    <div class="dashboard-header">
      <h1>Wiki Loves Monuments 2025{{ countryName !== 'Unknown' ? ` - ${countryName}` : '' }}</h1>
      <p class="subtitle">Tool Labs – Tools for Wiki Loves Photo Competitions</p>
    </div>

    <div v-if="loading" class="loading">
      <p>Loading statistics data...</p>
    </div>

    <div v-else-if="error" class="error">
      <h2>Error</h2>
      <p>{{ error }}</p>
      <p class="help-text">
        To use this dashboard, provide a Quarry JSON URL:<br>
        <code>/statistics?url=https://quarry.wmcloud.org/run/1072321/output/0/json</code>
      </p>
    </div>

    <div v-else-if="processedData && processedData.length > 0" class="dashboard-content">
      <!-- Overall Statistics -->
      <section class="stats-section">
        <h2>Overall Statistics</h2>
        <div class="stats-grid">
          <div class="stat-card">
            <div class="stat-label">Total Uploads</div>
            <div class="stat-value">{{ overallStats?.totalUploads.toLocaleString() || 0 }}</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">Unique Contributors</div>
            <div class="stat-value">{{ overallStats?.uniqueUsers.toLocaleString() || 0 }}</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">Total Size</div>
            <div class="stat-value">{{ formatFileSize(overallStats?.totalSize || 0) }}</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">Average File Size</div>
            <div class="stat-value">{{ formatFileSize(overallStats?.averageSize || 0) }}</div>
          </div>
          <div class="stat-card">
            <div class="stat-label">Date Range</div>
            <div class="stat-value">
              <span v-if="overallStats?.dateRange.start">{{ overallStats.dateRange.start }}</span>
              <span v-if="overallStats?.dateRange.start && overallStats?.dateRange.end"> - </span>
              <span v-if="overallStats?.dateRange.end">{{ overallStats.dateRange.end }}</span>
            </div>
          </div>
        </div>
      </section>

      <!-- Daily Uploads Chart - Main focus like reference design -->
      <section class="chart-section main-chart">
        <DailyUploadsChart :daily-data="dailyUploads" :height="400" />
      </section>

      <!-- User Contribution Chart -->
      <section class="chart-section">
        <UserContributionChart :user-data="userContributions" :show-top="20" />
      </section>

      <!-- File Size Distribution Chart -->
      <section class="chart-section">
        <FileSizeSpectrumChart :size-data="fileSizeDistribution" />
      </section>
    </div>
  </div>
</template>

<style scoped>
.statistics-dashboard {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.main-chart {
  margin-top: 2rem;
}

.dashboard-header {
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 2px solid #e5e7eb;
}

.dashboard-header h1 {
  font-size: 2rem;
  font-weight: 700;
  color: #111827;
  margin: 0 0 0.5rem 0;
}

.subtitle {
  font-size: 1rem;
  color: #6b7280;
  margin: 0;
}

.loading,
.error {
  text-align: center;
  padding: 3rem 1rem;
}

.error {
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: 8px;
  color: #991b1b;
}

.error h2 {
  color: #dc2626;
  margin-bottom: 1rem;
}

.help-text {
  margin-top: 1rem;
  font-size: 0.875rem;
  color: #6b7280;
}

.help-text code {
  background: #f3f4f6;
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  font-family: monospace;
  font-size: 0.8125rem;
}

.dashboard-content {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.stats-section {
  background: white;
  border-radius: 8px;
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

.stats-section h2 {
  font-size: 1.5rem;
  font-weight: 600;
  color: #111827;
  margin-bottom: 1.5rem;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
}

.stat-card {
  background: #f9fafb;
  border-radius: 6px;
  padding: 1rem;
  text-align: center;
}

.stat-label {
  font-size: 0.875rem;
  color: #6b7280;
  margin-bottom: 0.5rem;
  font-weight: 500;
}

.stat-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: #111827;
}

.chart-section {
  background: white;
  border-radius: 8px;
  padding: 1.5rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
}

@media (max-width: 768px) {
  .statistics-dashboard {
    padding: 1rem 0.5rem;
  }

  .dashboard-header h1 {
    font-size: 1.5rem;
  }

  .stats-grid {
    grid-template-columns: 1fr;
  }
}
</style>
