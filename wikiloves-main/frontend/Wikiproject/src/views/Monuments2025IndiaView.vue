<script setup>
import { ref, computed, onMounted } from 'vue'
import DailyUploadsChart from '@/components/DailyUploadsChart.vue'
import UserContributionChart from '@/components/UserContributionChart.vue'
import FileSizeSpectrumChart from '@/components/FileSizeSpectrumChart.vue'
import {
  parseQuarryData,
  getDailyUploads,
  getUserContributions,
  getFileSizeDistribution,
  getOverallStats,
  formatFileSize
} from '@/utils/quarryDataProcessor.js'

// Replace with your Quarry run URL for Wiki Loves Monuments 2025 India (category: Images_from_Wiki_Loves_Monuments_2025_in_India)
const INDIA_QUARRY_URL = 'https://quarry.wmcloud.org/run/1072321/output/0/json'

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

onMounted(async () => {
  try {
    let dataUrl = INDIA_QUARRY_URL
    if (dataUrl.includes('quarry.wmcloud.org')) {
      dataUrl = '/quarry' + new URL(dataUrl).pathname
    }

    const response = await fetch(dataUrl)
    if (!response.ok) {
      throw new Error(`Failed to fetch data: ${response.statusText}`)
    }

    const jsonData = await response.json()
    rawData.value = jsonData
    processedData.value = parseQuarryData(jsonData)

    if (processedData.value.length === 0) {
      error.value = 'No data found for India.'
    }

    loading.value = false
  } catch (err) {
    error.value = err.message || 'Failed to load India statistics'
    loading.value = false
  }
})
</script>

<template>
  <div class="monuments-india-view">
    <header class="page-header">
      <h1>Wiki Loves Monuments 2025 – India</h1>
      <p class="subtitle">Tool Labs – Tools for Wiki Loves Photo Competitions</p>
    </header>

    <div v-if="loading" class="loading">
      <p>Loading India statistics...</p>
    </div>

    <div v-else-if="error" class="error">
      <p>{{ error }}</p>
    </div>

    <div v-else-if="processedData && processedData.length > 0" class="dashboard-content">
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
        </div>
      </section>

      <section class="chart-section">
        <DailyUploadsChart :daily-data="dailyUploads" :height="400" />
      </section>

      <section class="chart-section">
        <UserContributionChart :user-data="userContributions" :show-top="20" />
      </section>

      <section class="chart-section">
        <FileSizeSpectrumChart :size-data="fileSizeDistribution" />
      </section>
    </div>
  </div>
</template>

<style scoped>
.monuments-india-view {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.page-header {
  margin-bottom: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 2px solid #e5e7eb;
}

.page-header h1 {
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

.dashboard-content {
  display: flex;
  flex-direction: column;
  gap: 2rem;
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
</style>
