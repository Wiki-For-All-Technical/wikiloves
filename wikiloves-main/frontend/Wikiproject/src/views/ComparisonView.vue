<script setup>
import { ref, onMounted, computed } from 'vue'
import { useCatalogStore } from '@/stores/catalog'
import Breadcrumbs from '@/components/Breadcrumbs.vue'
import SkeletonLoader from '@/components/SkeletonLoader.vue'

const catalog = useCatalogStore()
const comparisonData = ref(null)
const selectedYear = ref(null)
const loading = ref(false)

const availableYears = computed(() => {
  if (!catalog.competitions.length) return []
  const years = new Set()
  catalog.competitions.forEach(comp => {
    comp.yearly_stats?.forEach(stat => years.add(stat.year))
  })
  return Array.from(years).sort((a, b) => b - a)
})

const loadComparison = async () => {
  loading.value = true
  try {
    comparisonData.value = await catalog.loadComparison(selectedYear.value)
  } catch (error) {
    console.error('Failed to load comparison:', error)
  } finally {
    loading.value = false
  }
}

onMounted(async () => {
  await loadComparison()
})

const formatNumber = (value) => (value ? value.toLocaleString() : '—')
const formatPercent = (value) => (value ? `${value.toFixed(1)}%` : '—')
</script>

<template>
  <section class="comparison-view">
    <Breadcrumbs />
    
    <header class="page-header">
      <div class="header-content">
        <div>
          <h1>Campaign Comparison</h1>
          <p>Compare statistics across all Wiki Loves campaigns</p>
        </div>
        <div class="year-filter">
          <label for="year-select">Year:</label>
          <select 
            id="year-select" 
            v-model="selectedYear"
            @change="loadComparison"
            class="year-select"
          >
            <option :value="null">All Years (Latest)</option>
            <option v-for="year in availableYears" :key="year" :value="year">
              {{ year }}
            </option>
          </select>
        </div>
      </div>
    </header>

    <div v-if="loading" class="loading-container">
      <SkeletonLoader />
    </div>

    <div v-else-if="comparisonData" class="comparison-content">
      <div class="summary-stats">
        <div class="stat-card">
          <div class="stat-value">{{ formatNumber(comparisonData.total_campaigns) }}</div>
          <div class="stat-label">Campaigns</div>
        </div>
        <div class="stat-card">
          <div class="stat-value">{{ formatNumber(comparisonData.total_uploads) }}</div>
          <div class="stat-label">Total Uploads</div>
        </div>
      </div>

      <div class="comparison-table-wrapper">
        <table class="comparison-table">
          <thead>
            <tr>
              <th>Rank</th>
              <th>Campaign</th>
              <th>Year</th>
              <th>Uploads</th>
              <th>Countries</th>
              <th>Uploaders</th>
              <th>Images Used</th>
              <th>Usage Rate</th>
            </tr>
          </thead>
          <tbody>
            <tr 
              v-for="(campaign, index) in comparisonData.campaigns" 
              :key="campaign.slug"
              class="campaign-row"
            >
              <td class="rank-cell">{{ index + 1 }}</td>
              <td class="name-cell">
                <span class="campaign-name">{{ campaign.name }}</span>
              </td>
              <td class="year-cell">{{ campaign.year }}</td>
              <td class="num-cell">{{ formatNumber(campaign.uploads) }}</td>
              <td class="num-cell">{{ formatNumber(campaign.countries) }}</td>
              <td class="num-cell">{{ formatNumber(campaign.uploaders) }}</td>
              <td class="num-cell">{{ formatNumber(campaign.images_used) }}</td>
              <td class="num-cell">{{ formatPercent(campaign.images_used_pct) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>
</template>

<style scoped>
.comparison-view {
  max-width: 1400px;
  margin: 0 auto;
  padding: 2rem;
}

.page-header {
  border-bottom: 2px solid #e5e7eb;
  margin-bottom: 3rem;
  padding-bottom: 1.5rem;
}

.header-content {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1.5rem;
}

.page-header h1 {
  margin: 0;
  font-size: 2.5rem;
  font-weight: 700;
  color: #111827;
  margin-bottom: 0.5rem;
}

.page-header p {
  margin: 0;
  color: #6b7280;
  font-size: 1.125rem;
}

.year-filter {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.year-filter label {
  font-weight: 500;
  color: var(--text-secondary, #6b7280);
}

.year-select {
  padding: 0.5rem 1rem;
  border: 1px solid var(--border-color, #e5e7eb);
  border-radius: 6px;
  background: var(--bg-primary, #ffffff);
  color: var(--text-primary, #111827);
  font-size: 0.9375rem;
  cursor: pointer;
}

.summary-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  background: linear-gradient(135deg, var(--bg-card, #ffffff) 0%, var(--bg-secondary, #f9fafb) 100%);
  padding: 1.5rem;
  border-radius: 8px;
  border: 1px solid var(--border-color, #e5e7eb);
  text-align: center;
}

.stat-value {
  font-size: 2rem;
  font-weight: 700;
  color: var(--text-primary, #111827);
  margin-bottom: 0.5rem;
}

.stat-label {
  font-size: 0.875rem;
  color: var(--text-secondary, #6b7280);
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.comparison-table-wrapper {
  overflow-x: auto;
  border-radius: 8px;
  border: 1px solid var(--border-color, #e5e7eb);
  background: var(--bg-primary, #ffffff);
}

.comparison-table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  font-size: 0.9375rem;
}

.comparison-table thead {
  position: sticky;
  top: 0;
  z-index: 10;
}

.comparison-table th {
  background: linear-gradient(135deg, var(--bg-secondary, #f9fafb) 0%, var(--bg-hover, #f3f4f6) 100%);
  color: var(--text-secondary, #374151);
  font-weight: 700;
  font-size: 0.8125rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  padding: 1rem 0.75rem;
  text-align: left;
  border-bottom: 2px solid var(--border-color, #e5e7eb);
  white-space: nowrap;
}

.comparison-table td {
  padding: 1rem 0.75rem;
  border-bottom: 1px solid var(--border-color, #f3f4f6);
  color: var(--text-primary, #1f2937);
}

.comparison-table tbody tr:hover {
  background-color: var(--bg-hover, #f3f4f6);
}

.rank-cell {
  font-weight: 600;
  text-align: center;
  color: var(--text-secondary, #6b7280);
}

.name-cell a {
  color: var(--wiki-link, #2563eb);
  text-decoration: none;
  font-weight: 500;
}

.name-cell a:hover {
  text-decoration: underline;
}

.num-cell {
  text-align: right;
  font-variant-numeric: tabular-nums;
  font-weight: 500;
}

.year-cell {
  text-align: center;
}

.loading-container {
  padding: 3rem;
  text-align: center;
}

@media (max-width: 768px) {
  .comparison-view {
    padding: 1rem;
  }
  
  .header-content {
    flex-direction: column;
    align-items: flex-start;
  }
  
  .comparison-table {
    font-size: 0.875rem;
  }
  
  .comparison-table th,
  .comparison-table td {
    padding: 0.75rem 0.5rem;
  }
}
</style>









