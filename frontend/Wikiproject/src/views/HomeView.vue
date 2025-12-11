<script setup>
import { computed, onMounted, ref } from 'vue'
import { RouterLink } from 'vue-router'
import { useCatalogStore } from '@/stores/catalog'
import CountryLineChart from '@/components/CountryLineChart.vue'
import Breadcrumbs from '@/components/Breadcrumbs.vue'
import ExportButton from '@/components/ExportButton.vue'
import QuickStats from '@/components/QuickStats.vue'
import SkeletonLoader from '@/components/SkeletonLoader.vue'

const catalog = useCatalogStore()
const selectedCategory = ref(null)

const categories = [
  { value: null, label: 'All Campaigns' },
  { value: 'international', label: 'International' },
  { value: 'regional', label: 'Regional' },
  { value: 'local', label: 'Local' },
]

onMounted(() => {
  if (!catalog.competitions.length) {
    catalog.bootstrapHome()
  }
})

const navOrder = computed(() =>
  catalog.navigation.filter((entry) => entry.type === 'competition').map((entry) => entry.slug),
)

const competitionSections = computed(() => {
  if (!catalog.competitions.length) return []
  const order = navOrder.value
  const map = new Map(catalog.competitions.map((comp) => [comp.slug, comp]))
  let filtered = order.map((slug) => map.get(slug)).filter(Boolean)
  
  // Filter by category if selected
  if (selectedCategory.value) {
    filtered = filtered.filter((comp) => comp.category === selectedCategory.value)
  }
  
  return filtered
})

const handleCategoryChange = async (category) => {
  selectedCategory.value = category
  await catalog.loadCompetitions(category)
}

const formatNumber = (value) => (value ? value.toLocaleString() : '—')
const formatPercentCell = (value, pct) => {
  const roundedPct = pct ? Math.round(pct) : 0
  return `${formatNumber(value)} (${roundedPct}%)`
}

const sortedYearlyStats = (stats) => {
  return [...stats].sort((a, b) => a.year - b.year)
}

const getCompetitionStats = (competition) => {
  if (!competition.yearly_stats || competition.yearly_stats.length === 0) {
    return {
      totalUploads: 0,
      totalCountries: 0,
      totalUploaders: 0,
      usageRate: 0
    }
  }
  
  const latest = competition.yearly_stats[0]
  const totalUploads = latest.uploads || 0
  const totalCountries = latest.countries || 0
  const totalUploaders = latest.uploaders || 0
  const usageRate = latest.images_used_pct || 0
  
  return {
    totalUploads,
    totalCountries,
    totalUploaders,
    usageRate
  }
}
</script>

<template>
  <section class="home-view">
    <Breadcrumbs />
    
    <header class="page-header">
      <div class="header-content">
        <div>
          <h1>Wiki Loves Competitions Tools</h1>
          <p>Tool Labs – Tools for Wiki Loves Photo Competitions</p>
        </div>
        <div class="category-filter">
          <label for="category-select">Filter by category:</label>
          <select 
            id="category-select" 
            v-model="selectedCategory"
            @change="handleCategoryChange(selectedCategory)"
            class="category-select"
          >
            <option v-for="cat in categories" :key="cat.value" :value="cat.value">
              {{ cat.label }}
            </option>
          </select>
        </div>
      </div>
    </header>

    <article v-for="competition in competitionSections" :key="competition.slug" class="competition-block">
      <div class="competition-header">
        <h2>{{ competition.name }}</h2>
        <p v-if="competition.tagline" class="competition-tagline">{{ competition.tagline }}</p>
      </div>
      
      <div v-if="!competition.has_data || !competition.yearly_stats || competition.yearly_stats.length === 0" class="no-data-message">
        <p>📊 No statistics data available for this campaign yet.</p>
        <p class="no-data-subtitle">Data can be added using Quarry queries or by updating the database.</p>
      </div>
      
      <template v-else>
        <QuickStats :stats="getCompetitionStats(competition)" />
        
        <div class="line-chart-wrapper-home">
          <CountryLineChart :yearly-stats="competition.yearly_stats" :height="400" />
        </div>
        
        <div class="table-header-home">
          <h3>Yearly Statistics</h3>
          <ExportButton :data="sortedYearlyStats(competition.yearly_stats)" :filename="competition.name" type="csv" />
        </div>
        
        <div class="table-wrapper">
          <table class="comparison-table">
            <thead>
              <tr>
                <th>Year</th>
                <th>Countries</th>
                <th>Uploads</th>
                <th>Images used in the wikis</th>
                <th>Uploaders</th>
                <th>Uploaders registered after competition start</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="year in sortedYearlyStats(competition.yearly_stats)" :key="year.year">
                <td class="year-cell">
                  <RouterLink :to="`/${competition.path_segment}/${year.year}`">{{ year.year }}</RouterLink>
                </td>
                <td class="num-cell">{{ formatNumber(year.countries) }}</td>
                <td class="num-cell">{{ formatNumber(year.uploads) }}</td>
                <td class="num-cell">{{ formatPercentCell(year.images_used, year.images_used_pct) }}</td>
                <td class="num-cell">{{ formatNumber(year.uploaders) }}</td>
                <td class="num-cell">{{ formatPercentCell(year.new_uploaders, year.new_uploaders_pct) }}</td>
              </tr>
            </tbody>
          </table>
        </div>
      </template>
    </article>
  </section>
</template>

<style scoped>
.home-view {
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

.category-filter {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.category-filter label {
  font-weight: 500;
  color: var(--text-secondary, #6b7280);
}

.category-select {
  padding: 0.5rem 1rem;
  border: 1px solid var(--border-color, #e5e7eb);
  border-radius: 6px;
  background: var(--bg-primary, #ffffff);
  color: var(--text-primary, #111827);
  font-size: 0.9375rem;
  cursor: pointer;
  transition: all 0.2s ease;
}

.category-select:hover {
  border-color: var(--accent-color, #2563eb);
}

.category-select:focus {
  outline: none;
  border-color: var(--accent-color, #2563eb);
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
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

.competition-block {
  margin-bottom: 4rem;
  background: linear-gradient(135deg, var(--bg-card, #ffffff) 0%, var(--bg-secondary, #f9fafb) 100%);
  padding: 2.5rem;
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  border: 1px solid var(--border-color, #e5e7eb);
  transition: all 0.3s ease;
}

.competition-header {
  margin-bottom: 2rem;
}

.competition-header h2 {
  font-size: 2rem;
  font-weight: 700;
  color: var(--text-primary, #111827);
  margin: 0;
  padding-bottom: 0.5rem;
  border-bottom: 3px solid #1f8a70;
}

.competition-tagline {
  margin: 0.5rem 0 0 0;
  color: var(--text-secondary, #6b7280);
  font-size: 1rem;
  font-style: italic;
}

.no-data-message {
  background: var(--bg-secondary, #f9fafb);
  border: 2px dashed var(--border-color, #e5e7eb);
  border-radius: 8px;
  padding: 3rem 2rem;
  text-align: center;
  margin: 2rem 0;
}

.no-data-message p {
  margin: 0.5rem 0;
  color: var(--text-secondary, #6b7280);
  font-size: 1.125rem;
}

.no-data-subtitle {
  font-size: 0.9375rem !important;
  color: var(--text-tertiary, #9ca3af) !important;
}

.table-header-home {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1.5rem;
  flex-wrap: wrap;
  gap: 1rem;
}

.table-header-home h3 {
  margin: 0;
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--text-primary, #111827);
}

.line-chart-wrapper-home {
  background: var(--bg-primary, #ffffff);
  padding: 2rem;
  border-radius: 8px;
  border: 1px solid var(--border-color, #e5e7eb);
  margin-bottom: 2rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.05);
  overflow-x: auto;
}

.table-wrapper {
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

.comparison-table th:first-child {
  border-top-left-radius: 8px;
}

.comparison-table th:last-child {
  border-top-right-radius: 8px;
}

.comparison-table td {
  padding: 1rem 0.75rem;
  border-bottom: 1px solid var(--border-color, #f3f4f6);
  transition: background-color 0.2s ease;
  color: var(--text-primary, #1f2937);
}

.comparison-table tbody tr {
  transition: all 0.2s ease;
}

.comparison-table tbody tr:nth-child(even) {
  background-color: var(--bg-secondary, #f9fafb);
}

.comparison-table tbody tr:hover {
  background-color: var(--bg-hover, #f3f4f6);
  transform: scale(1.001);
}

.comparison-table tbody tr:last-child td {
  border-bottom: none;
}

.comparison-table tbody tr:last-child td:first-child {
  border-bottom-left-radius: 8px;
}

.comparison-table tbody tr:last-child td:last-child {
  border-bottom-right-radius: 8px;
}

.year-cell {
  font-weight: 600;
}

.year-cell a {
  color: var(--wiki-link, #2563eb);
  text-decoration: none;
  transition: color 0.2s ease;
  font-weight: 500;
}

.year-cell a:hover {
  color: var(--accent-color, #1d4ed8);
  text-decoration: underline;
}

.num-cell {
  text-align: right;
  font-variant-numeric: tabular-nums;
  font-weight: 500;
  color: var(--text-primary, #1f2937);
}

@media (max-width: 768px) {
  .home-view {
    padding: 1rem;
  }
  
  .competition-block {
    padding: 1.5rem;
  }
  
  .competition-header h2 {
    font-size: 1.5rem;
  }
  
  .chart-container-wrapper {
    padding: 1rem;
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
