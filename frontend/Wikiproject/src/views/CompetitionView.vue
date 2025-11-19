<script setup>
import { computed, onMounted, watch } from 'vue'
import { useRoute } from 'vue-router'
import { useCatalogStore } from '@/stores/catalog'
import StatCard from '@/components/StatCard.vue'
import CompetitionChart from '@/components/CompetitionChart.vue'

const route = useRoute()
const catalog = useCatalogStore()

const competition = computed(() => catalog.competitionDetail)
const loading = computed(() => catalog.loading.competitionDetail || catalog.loading.navigation)
const error = computed(() => catalog.error)
const segmentResolved = computed(() => {
  const segment = route.params.segment
  if (!segment) return false
  return !!catalog.resolveSegment(segment)
})

// Helper to get the current year from the list of country stats
const currentYearStats = computed(() => {
  if (!competition.value || !competition.value.yearly_stats) return []
  
  // Use the year from route params if available, otherwise use the latest year
  const requestedYear = route.params.year ? parseInt(route.params.year) : null
  let yearEntry = null
  
  if (requestedYear) {
    yearEntry = competition.value.yearly_stats.find(
      entry => entry.year === requestedYear
    )
  }
  
  // Fallback to latest year if requested year not found or no year specified
  if (!yearEntry) {
    yearEntry = competition.value.yearly_stats[0]
  }
  
  return yearEntry ? (yearEntry.country_stats || []) : []
})

const currentYear = computed(() => {
  if (!competition.value || !competition.value.yearly_stats) return null
  
  const requestedYear = route.params.year ? parseInt(route.params.year) : null
  if (requestedYear) {
    const yearEntry = competition.value.yearly_stats.find(
      entry => entry.year === requestedYear
    )
    if (yearEntry) return yearEntry.year
  }
  
  return competition.value.yearly_stats[0]?.year || null
})

onMounted(async () => {
  // Ensure navigation is loaded before trying to resolve segment
  if (!catalog.navigation.length) {
    await catalog.loadNavigation()
  }
  loadRouteData()
})

watch(
  () => [route.params.segment, route.params.year],
  () => loadRouteData(),
  { immediate: false }
)

async function loadRouteData() {
  const segment = route.params.segment
  if (!segment) return
  
  // Clear any previous errors
  catalog.error = null
  
  // Ensure navigation is loaded
  if (!catalog.navigation.length) {
    await catalog.loadNavigation()
  }
  
  const slug = catalog.resolveSegment(segment)
  console.log('Route segment:', segment, 'Resolved slug:', slug, 'Available segments:', Object.keys(catalog.segmentLookup))
  
  if (slug) {
    try {
      await catalog.loadCompetitionDetail(slug)
      console.log('Competition loaded:', catalog.competitionDetail)
      if (catalog.competitionDetail) {
        console.log('Yearly stats:', catalog.competitionDetail.yearly_stats)
        if (catalog.competitionDetail.yearly_stats && catalog.competitionDetail.yearly_stats.length > 0) {
          const year = route.params.year ? parseInt(route.params.year) : catalog.competitionDetail.yearly_stats[0].year
          const yearEntry = catalog.competitionDetail.yearly_stats.find(e => e.year === year)
          console.log(`Year ${year} entry:`, yearEntry)
          if (yearEntry) {
            console.log('Country stats:', yearEntry.country_stats)
          }
        }
      }
    } catch (err) {
      console.error('Error loading competition detail:', err)
    }
  } else {
    console.warn(`Could not resolve segment "${segment}" to a competition slug. Available segments:`, Object.keys(catalog.segmentLookup))
  }
}

function formatNum(num) {
  return new Intl.NumberFormat('en-US').format(num)
}
</script>

<template>
  <div v-if="loading" class="loading-state">Loading competition data...</div>
  <div v-else-if="error" class="error-state">
    <h2>Error loading data</h2>
    <p>Could not load competition details. Please try again later.</p>
    <p v-if="error">{{ error.message || error }}</p>
  </div>
  <div v-else-if="!segmentResolved && route.params.segment" class="error-state">
    <h2>Competition not found</h2>
    <p>Could not find competition for segment "{{ route.params.segment }}".</p>
  </div>

  <div v-else-if="!competition && !loading" class="error-state">
    <h2>No data available</h2>
    <p>Competition data could not be loaded. Please check:</p>
    <ul>
      <li>Is the backend API running on http://127.0.0.1:5000?</li>
      <li>Check the browser console for error messages</li>
    </ul>
    <p>Debug info: Segment="{{ route.params.segment }}", Year="{{ route.params.year }}"</p>
  </div>

  <div v-else-if="competition" class="competition-view">
    <header class="comp-header" :style="{ borderBottomColor: competition.accent_color }">
      <div class="header-content">
        <div class="logo-area">
          <img v-if="competition.logo" :src="competition.logo" :alt="competition.name" class="comp-logo" />
          <h1 v-else>{{ competition.name }}</h1>
        </div>
        <div class="header-text">
          <h1>{{ competition.short_label || competition.name }}</h1>
          <p class="tagline">{{ competition.tagline }}</p>
        </div>
      </div>
    </header>

    <section class="stats-grid">
      <StatCard
        label="Participating Countries"
        :value="competition.spotlight.countries"
        icon="🌍"
        :color="competition.accent_color"
      />
      <StatCard
        label="Total Uploads"
        :value="competition.spotlight.uploads"
        :delta="competition.spotlight.uploads_delta"
        icon="📸"
        :color="competition.accent_color"
      />
      <StatCard
        label="Images Used in Wikis"
        :value="competition.spotlight.images_used"
        sublabel="usage rate"
        icon="📖"
        :color="competition.accent_color"
      />
      <StatCard
        label="Uploaders"
        :value="competition.spotlight.uploaders"
        :subvalue="competition.spotlight.new_uploaders"
        sublabel="newcomers"
        icon="👥"
        :color="competition.accent_color"
      />
    </section>

    <section class="chart-section">
      <h3>Upload Trends (Last 6 Years)</h3>
      <div class="chart-container">
        <CompetitionChart :years="competition.yearly_stats" />
      </div>
    </section>

    <section class="table-section" v-if="currentYearStats.length > 0">
      <h3>Participating Countries ({{ currentYear }})</h3>
      <div class="table-wrapper">
        <table>
          <thead>
            <tr>
              <th class="rank-col">#</th>
              <th class="country-col">Country</th>
              <th class="num-col">Images*</th>
              <th class="num-col">Images used in the wikis</th>
              <th class="num-col">Uploaders</th>
              <th class="num-col">Uploaders registered after competition start</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="stat in currentYearStats" :key="stat.name">
              <td class="rank-col">{{ stat.rank }}</td>
              <td class="country-col">
                <router-link :to="{ name: 'country', params: { slug: stat.name.toLowerCase().replace(/ /g, '-') } }">
                  {{ stat.name }}
                </router-link>
              </td>
              <td class="num-col">{{ formatNum(stat.uploads) }}</td>
              <td class="num-col">{{ formatNum(stat.images_used) }} ({{ Math.round(stat.images_used_pct || 0) }}%)</td>
              <td class="num-col">{{ formatNum(stat.uploaders) }}</td>
              <td class="num-col">{{ formatNum(stat.new_uploaders) }} ({{ Math.round(stat.new_uploaders_pct || 0) }}%)</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>
    <div v-else class="no-data-msg">
      No detailed country data available for this year.
    </div>
  </div>
</template>

<style scoped>
.competition-view {
  padding: 2rem;
  max-width: 1200px;
  margin: 0 auto;
}

.comp-header {
  display: flex;
  align-items: center;
  margin-bottom: 2rem;
  padding-bottom: 1rem;
  border-bottom: 4px solid #ccc; /* Fallback */
}

.header-content {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.comp-logo {
  height: 80px;
  width: auto;
}

.header-text h1 {
  margin: 0;
  font-size: 2rem;
  color: #2c3e50;
}

.tagline {
  margin: 0.5rem 0 0 0;
  color: #666;
  font-style: italic;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
  gap: 1.5rem;
  margin-bottom: 3rem;
}

.chart-section {
  margin-bottom: 3rem;
  background: #fff;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

/* Table Styles */
.table-section {
  background: #fff;
  padding: 1.5rem;
  border-radius: 8px;
  box-shadow: 0 2px 8px rgba(0,0,0,0.05);
}

.table-section h3 {
  margin-top: 0;
  margin-bottom: 1rem;
  color: #2c3e50;
}

.table-wrapper {
  overflow-x: auto;
}

table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.95rem;
}

th {
  text-align: left;
  padding: 1rem;
  background-color: #f8f9fa;
  color: #666;
  font-weight: 600;
  border-bottom: 2px solid #eee;
}

td {
  padding: 1rem;
  border-bottom: 1px solid #eee;
}

tr:hover {
  background-color: #f8f9fa;
}

.num-col {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

.rank-col {
  text-align: center;
  width: 50px;
  color: #999;
}

.country-col a {
  color: #2c3e50;
  text-decoration: none;
  font-weight: 500;
}

.country-col a:hover {
  text-decoration: underline;
  color: #3eaf7c; /* Default Vue green as fallback accent */
}

.loading-state, .error-state {
  text-align: center;
  padding: 4rem;
  color: #666;
}

.no-data-msg {
  text-align: center;
  padding: 2rem;
  color: #888;
  font-style: italic;
}
</style>