<script setup>
import { computed, onMounted, watch, ref } from 'vue'
import { useRoute } from 'vue-router'
import { useCatalogStore } from '@/stores/catalog'
import StatCard from '@/components/StatCard.vue'
import CountryLineChart from '@/components/CountryLineChart.vue'
import AreaChart from '@/components/AreaChart.vue'
import Breadcrumbs from '@/components/Breadcrumbs.vue'
import TableFilters from '@/components/TableFilters.vue'
import ExportButton from '@/components/ExportButton.vue'
import SkeletonLoader from '@/components/SkeletonLoader.vue'
import QuickStats from '@/components/QuickStats.vue'
import TimelineSlider from '@/components/TimelineSlider.vue'
import ComparisonView from '@/components/ComparisonView.vue'
import StatsCalculator from '@/components/StatsCalculator.vue'
import CountryStatsSection from '@/components/CountryStatsSection.vue'

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
const rawYearStats = computed(() => {
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

const filteredStats = ref([])
const currentYearStats = computed(() => filteredStats.value.length > 0 ? filteredStats.value : rawYearStats.value)

const handleFiltered = (filtered) => {
  filteredStats.value = filtered
}

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

const yearRange = computed(() => {
  if (!competition.value || !competition.value.yearly_stats) return null
  const years = competition.value.yearly_stats.map(e => e.year).sort()
  if (years.length === 0) return null
  if (years.length === 1) return `${years[0]}`
  return `${years[years.length - 1]} - ${years[0]}`
})

const currentYearData = computed(() => {
  if (!competition.value || !competition.value.yearly_stats) return null
  
  const requestedYear = route.params.year ? parseInt(route.params.year) : null
  let yearEntry = null
  
  if (requestedYear) {
    yearEntry = competition.value.yearly_stats.find(
      entry => entry.year === requestedYear
    )
  }
  
  if (!yearEntry) {
    yearEntry = competition.value.yearly_stats[0]
  }
  
  return yearEntry
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
  
  if (slug) {
    try {
      await catalog.loadCompetitionDetail(slug)
    } catch (err) {
      console.error('Error loading competition detail:', err)
    }
  }
}

function formatNum(num) {
  return new Intl.NumberFormat('en-US').format(num)
}
</script>

<template>
  <div v-if="loading" class="loading-state">
    <SkeletonLoader type="card" height="400px" />
    <SkeletonLoader type="table" :lines="5" />
  </div>
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
    <Breadcrumbs />
    
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

    <!-- Summary Section (only show when a specific year is selected) -->
    <section class="summary-section" v-if="currentYearData && route.params.year">
      <div class="summary-date">{{ yearRange }}</div>
      
      <div class="summary-total-box">
        <div class="summary-total-label">Total</div>
        <div class="summary-total-value">{{ formatNum(currentYearData.uploads) }}</div>
        <div class="summary-total-unit">Images</div>
      </div>
      
      <div class="summary-stats-row">
        <div class="summary-stat-box">
          <div class="summary-stat-value">{{ formatNum(currentYearData.countries) }}</div>
          <div class="summary-stat-label">Countries</div>
        </div>
        <div class="summary-stat-box">
          <div class="summary-stat-value">{{ formatNum(currentYearData.images_used) }}</div>
          <div class="summary-stat-label">Images Used</div>
        </div>
        <div class="summary-stat-box">
          <div class="summary-stat-value">{{ formatNum(currentYearData.uploaders) }}</div>
          <div class="summary-stat-label">Uploaders</div>
        </div>
      </div>
    </section>

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

    <section class="line-chart-section">
      <div class="line-chart-wrapper">
        <CountryLineChart :yearly-stats="competition.yearly_stats" :height="400" />
      </div>
    </section>

    <section class="timeline-section" v-if="competition.yearly_stats && competition.yearly_stats.length > 0">
      <TimelineSlider
        :years="competition.yearly_stats.map(y => y.year)"
        :current-year="currentYear"
        @year-change="(year) => $router.push(`/${route.params.segment}/${year}`)"
      />
    </section>

    <section class="stats-section" v-if="competition.yearly_stats && competition.yearly_stats.length > 0">
      <StatsCalculator :data="competition.yearly_stats" value-field="uploads" />
    </section>

    <section class="area-chart-section">
      <h3>Uploads Over Time</h3>
      <div class="area-chart-wrapper">
        <AreaChart
          :data="competition.yearly_stats.slice().reverse().slice(-12).map(y => ({ year: y.year, value: y.uploads, label: y.year.toString() }))"
          color="#dc2626"
          fill-color="#fecaca"
          :height="300"
        />
      </div>
    </section>

    <!-- All Years Table (like reference website) -->
    <section class="table-section" v-if="competition.yearly_stats && competition.yearly_stats.length > 0">
      <div class="table-header">
        <h3>Wiki Loves Campaign Statistics by Year</h3>
      </div>
      <div class="table-wrapper">
        <table>
          <thead>
            <tr>
              <th class="year-col">YEAR</th>
              <th class="num-col">COUNTRIES</th>
              <th class="num-col">UPLOADS</th>
              <th class="num-col">IMAGES USED IN THE WIKIS</th>
              <th class="num-col">UPLOADERS</th>
              <th class="num-col">UPLOADERS REGISTERED AFTER COMPETITION START</th>
            </tr>
          </thead>
                          <tbody>
                            <tr v-for="yearStat in competition.yearly_stats.slice().reverse()" :key="yearStat.year">
                              <td class="year-col">
                                <router-link :to="`/${route.params.segment}/${yearStat.year}`" class="year-link">
                                  {{ yearStat.year }}
                                </router-link>
                              </td>
                              <td class="num-col">
                                <router-link v-if="yearStat.countries > 0" :to="`/${route.params.segment}/${yearStat.year}`" class="country-count-link">
                                  {{ formatNum(yearStat.countries) }}
                                </router-link>
                                <span v-else>—</span>
                              </td>
                              <td class="num-col">{{ formatNum(yearStat.uploads) }}</td>
                              <td class="num-col">
                                {{ formatNum(yearStat.images_used) }} 
                                <span class="percentage">({{ Math.round((yearStat.images_used / yearStat.uploads * 100) || 0) }}%)</span>
                              </td>
                              <td class="num-col">{{ formatNum(yearStat.uploaders) }}</td>
                              <td class="num-col">
                                <span v-if="yearStat.new_uploaders > 0">
                                  {{ formatNum(yearStat.new_uploaders) }} 
                                  <span class="percentage">({{ Math.round((yearStat.new_uploaders / yearStat.uploaders * 100) || 0) }}%)</span>
                                </span>
                                <span v-else>— <span class="percentage">(0%)</span></span>
                              </td>
                            </tr>
                          </tbody>
        </table>
      </div>
    </section>

    <!-- Country Breakdown Table (shown when a specific year is selected) -->
    <section class="table-section" v-if="rawYearStats.length > 0 && route.params.year">
      <div class="table-header">
        <h3>Participating Countries ({{ currentYear }})</h3>
      </div>
      <TableFilters :data="rawYearStats" search-placeholder="Search countries..." @filtered="handleFiltered" />
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
                <router-link :to="`/${route.params.segment}/${currentYear}/${stat.name}`">
                  {{ stat.name }}
                </router-link>
              </td>
              <td class="num-col">
                <a
                  :href="`/images?event=${competition.slug}&year=${currentYear}&country=${encodeURIComponent(stat.name)}`"
                  class="uploads-link"
                >
                  {{ formatNum(stat.uploads) }}
                </a>
              </td>
              <td class="num-col">{{ formatNum(stat.images_used) }} ({{ Math.round(stat.images_used_pct || 0) }}%)</td>
              <td class="num-col">
                <router-link
                  :to="`/${route.params.segment}/${currentYear}/${stat.name}/users`"
                  class="uploaders-link"
                >
                  {{ formatNum(stat.uploaders) }}
                </router-link>
              </td>
              <td class="num-col">{{ formatNum(stat.new_uploaders) }} ({{ Math.round(stat.new_uploaders_pct || 0) }}%)</td>
            </tr>
          </tbody>
        </table>
      </div>
    </section>

    <!-- Country Statistics Section (all countries across all years) -->
    <CountryStatsSection
      v-if="competition.yearly_stats && competition.yearly_stats.length > 0"
      :yearly-stats="competition.yearly_stats"
      :campaign-slug="competition.slug"
    />
  </div>
</template>

<style scoped>
.competition-view {
  padding: 2.5rem;
  max-width: 1400px;
  margin: 0 auto;
  animation: fadeIn 0.5s ease-in;
  color: var(--text-primary, #111827);
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

.comp-header {
  display: flex;
  align-items: center;
  margin-bottom: 3rem;
  padding: 2rem;
  padding-bottom: 1.5rem;
  border-bottom: 3px solid;
  border-image: linear-gradient(90deg, v-bind('competition?.accent_color || "#1f8a70"'), transparent) 1;
  background: linear-gradient(135deg, var(--bg-card, rgba(255, 255, 255, 0.9)) 0%, var(--bg-secondary, rgba(249, 250, 251, 0.9)) 100%);
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
  transition: all 0.3s ease;
}

.comp-header:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.header-content {
  display: flex;
  align-items: center;
  gap: 2rem;
  width: 100%;
}

.logo-area {
  flex-shrink: 0;
}

.comp-logo {
  height: 90px;
  width: auto;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
  transition: transform 0.3s ease;
}

.comp-header:hover .comp-logo {
  transform: scale(1.05);
}

.header-text {
  flex: 1;
}

.header-text h1 {
  margin: 0;
  font-size: 2.5rem;
  font-weight: 800;
  color: var(--text-primary, #111827);
  background: linear-gradient(135deg, var(--text-primary, #111827) 0%, var(--text-secondary, #374151) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  line-height: 1.2;
}

.tagline {
  margin: 0.75rem 0 0 0;
  color: var(--text-secondary, #6b7280);
  font-style: italic;
  font-size: 1.125rem;
  font-weight: 400;
}

/* Summary Section */
.summary-section {
  margin-bottom: 3rem;
  text-align: center;
}

.summary-date {
  font-size: 1rem;
  color: #374151;
  margin-bottom: 1.5rem;
  font-weight: 500;
}

.summary-total-box {
  border: 3px solid #dc2626;
  border-radius: 12px;
  padding: 2.5rem 2rem;
  margin: 0 auto 2rem;
  max-width: 400px;
  background: linear-gradient(135deg, #ffffff 0%, #fef2f2 100%);
  box-shadow: 0 4px 12px rgba(220, 38, 38, 0.15);
  transition: all 0.3s ease;
}

.summary-total-box:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 20px rgba(220, 38, 38, 0.25);
}

.summary-total-label {
  font-size: 0.875rem;
  color: #dc2626;
  font-weight: 700;
  text-transform: uppercase;
  letter-spacing: 1px;
  margin-bottom: 0.5rem;
}

.summary-total-value {
  font-size: 3.5rem;
  font-weight: 900;
  color: #dc2626;
  line-height: 1;
  margin: 0.5rem 0;
  background: linear-gradient(135deg, #dc2626 0%, #b91c1c 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.summary-total-unit {
  font-size: 1.25rem;
  color: #991b1b;
  font-weight: 600;
  margin-top: 0.5rem;
}

.summary-stats-row {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 1.5rem;
  max-width: 900px;
  margin: 0 auto;
}

.summary-stat-box {
  border: 2px solid #2563eb;
  border-radius: 10px;
  padding: 2rem 1.5rem;
  background: linear-gradient(135deg, #ffffff 0%, #eff6ff 100%);
  box-shadow: 0 2px 8px rgba(37, 99, 235, 0.1);
  transition: all 0.3s ease;
}

.summary-stat-box:hover {
  transform: translateY(-4px);
  box-shadow: 0 6px 16px rgba(37, 99, 235, 0.2);
  border-color: #1d4ed8;
}

.summary-stat-value {
  font-size: 2.5rem;
  font-weight: 800;
  color: #2563eb;
  line-height: 1;
  margin-bottom: 0.75rem;
  background: linear-gradient(135deg, #2563eb 0%, #1e40af 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.summary-stat-label {
  font-size: 1rem;
  color: #1e40af;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
  gap: 1.75rem;
  margin-bottom: 3rem;
}

.line-chart-section {
  margin-bottom: 3rem;
  background: linear-gradient(135deg, var(--bg-card, #ffffff) 0%, var(--bg-secondary, #f9fafb) 100%);
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  border: 1px solid var(--border-color, #e5e7eb);
  transition: all 0.3s ease;
}

.timeline-section {
  margin-bottom: 3rem;
}

.line-chart-section:hover {
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15), 0 4px 10px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.line-chart-wrapper {
  background: var(--bg-primary, #ffffff);
  padding: 1.5rem;
  border-radius: 8px;
  border: 1px solid var(--border-color, #e5e7eb);
}

.area-chart-section {
  margin-bottom: 3rem;
  background: linear-gradient(135deg, #ffffff 0%, #f9fafb 100%);
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  border: 1px solid #e5e7eb;
  transition: all 0.3s ease;
}

.area-chart-section:hover {
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15), 0 4px 10px rgba(0, 0, 0, 0.1);
  transform: translateY(-2px);
}

.area-chart-section h3 {
  margin-top: 0;
  margin-bottom: 1.5rem;
  color: var(--text-primary, #111827);
  font-size: 1.375rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.area-chart-section h3::before {
  content: '';
  width: 4px;
  height: 24px;
  background: v-bind('competition?.accent_color || "#1f8a70"');
  border-radius: 2px;
}

.area-chart-wrapper {
  background: #ffffff;
  padding: 1.5rem;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
}

/* Table Styles */
.table-section {
  background: linear-gradient(135deg, var(--bg-card, #ffffff) 0%, var(--bg-secondary, #f9fafb) 100%);
  padding: 2rem;
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  border: 1px solid var(--border-color, #e5e7eb);
}

.table-header {
  margin-bottom: 1.5rem;
}

.table-section h3 {
  margin: 0;
  color: var(--text-primary, #111827);
  font-size: 1.5rem;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.table-section h3::before {
  content: '';
  width: 4px;
  height: 24px;
  background: v-bind('competition?.accent_color || "#1f8a70"');
  border-radius: 2px;
}

.table-wrapper {
  overflow-x: auto;
  border-radius: 8px;
  border: 1px solid var(--border-color, #e5e7eb);
  background: var(--bg-primary, #fff);
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
  padding: 1.25rem 1rem;
  background: linear-gradient(135deg, var(--bg-secondary, #f9fafb) 0%, var(--bg-hover, #f3f4f6) 100%);
  color: var(--text-secondary, #374151);
  font-weight: 700;
  font-size: 0.8125rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  border-bottom: 2px solid var(--border-color, #e5e7eb);
  white-space: nowrap;
  position: relative;
}

th:first-child {
  border-top-left-radius: 8px;
}

th:last-child {
  border-top-right-radius: 8px;
}

th::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  right: 0;
  height: 2px;
  background: v-bind('competition?.accent_color || "#1f8a70"');
  transform: scaleX(0);
  transition: transform 0.3s ease;
}

thead:hover th::after {
  transform: scaleX(1);
}

td {
  padding: 1.125rem 1rem;
  border-bottom: 1px solid var(--border-color, #f3f4f6);
  transition: all 0.2s ease;
  color: var(--text-primary, #1f2937);
}

tbody tr {
  transition: all 0.2s ease;
}

tbody tr:nth-child(even) {
  background-color: var(--bg-secondary, #f9fafb);
}

tbody tr:hover {
  background-color: var(--bg-hover, #f3f4f6);
  transform: scale(1.01);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}

tbody tr:last-child td {
  border-bottom: none;
}

tbody tr:last-child td:first-child {
  border-bottom-left-radius: 8px;
}

tbody tr:last-child td:last-child {
  border-bottom-right-radius: 8px;
}

.num-col {
  text-align: right;
  font-variant-numeric: tabular-nums;
  font-weight: 600;
  color: var(--text-primary, #1f2937);
}

.rank-col {
  text-align: center;
  width: 60px;
  color: var(--text-secondary, #9ca3af);
  font-weight: 700;
  font-size: 0.875rem;
}

.year-col {
  text-align: center;
  width: 80px;
  color: var(--text-primary, #1f2937);
  font-weight: 700;
  font-size: 0.9375rem;
}

.year-link {
  color: #2563eb;
  text-decoration: none;
  font-weight: 700;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  transition: all 0.2s ease;
  display: inline-block;
}

.year-link:hover {
  background-color: #eff6ff;
  color: #1d4ed8;
  transform: scale(1.05);
}

.country-count-link {
  color: #059669;
  text-decoration: none;
  font-weight: 600;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  transition: all 0.2s ease;
  display: inline-block;
}

.country-count-link:hover {
  background-color: #ecfdf5;
  color: #047857;
  transform: scale(1.05);
}

.percentage {
  color: var(--text-secondary, #6b7280);
  font-weight: 400;
  font-size: 0.875rem;
}

.country-col {
  font-weight: 600;
}

.country-col a {
  color: var(--text-primary, #1f2937);
  text-decoration: none;
  font-weight: 600;
  transition: all 0.2s ease;
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  margin: -0.25rem -0.5rem;
}

.country-col a::after {
  content: '→';
  opacity: 0;
  transform: translateX(-4px);
  transition: all 0.2s ease;
  font-size: 0.875rem;
  color: v-bind('competition?.accent_color || "#1f8a70"');
}

.country-col a:hover {
  background-color: var(--bg-hover, #f3f4f6);
  color: v-bind('competition?.accent_color || "#1f8a70"');
  transform: translateX(2px);
}

.country-col a:hover::after {
  opacity: 1;
  transform: translateX(0);
}

.loading-state {
  text-align: center;
  padding: 6rem 2rem;
  color: var(--text-secondary, #6b7280);
}

.loading-state::before {
  content: '';
  display: inline-block;
  width: 48px;
  height: 48px;
  border: 4px solid #e5e7eb;
  border-top-color: v-bind('competition?.accent_color || "#1f8a70"');
  border-radius: 50%;
  animation: spin 1s linear infinite;
  margin-bottom: 1.5rem;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.error-state {
  text-align: center;
  padding: 4rem 2rem;
  background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%);
  border-radius: 12px;
  border: 1px solid #fecaca;
  color: #991b1b;
  margin: 2rem 0;
}

.error-state h2 {
  color: #dc2626;
  font-size: 1.75rem;
  margin-bottom: 1rem;
}

.error-state p {
  color: #7f1d1d;
  margin: 0.5rem 0;
}

.error-state ul {
  text-align: left;
  display: inline-block;
  margin: 1rem 0;
  color: #7f1d1d;
}

.no-data-msg {
  text-align: center;
  padding: 4rem 2rem;
  color: #9ca3af;
  font-style: italic;
  background: #f9fafb;
  border-radius: 12px;
  border: 2px dashed #d1d5db;
  margin: 2rem 0;
}

.no-data-msg::before {
  content: '📊';
  display: block;
  font-size: 3rem;
  margin-bottom: 1rem;
  opacity: 0.5;
}

@media (max-width: 768px) {
  .competition-view {
    padding: 1.5rem;
  }
  
  .comp-header {
    padding: 1.5rem;
    flex-direction: column;
    text-align: center;
  }
  
  .header-content {
    flex-direction: column;
    gap: 1.5rem;
  }
  
  .header-text h1 {
    font-size: 2rem;
  }
  
  .summary-total-box {
    padding: 2rem 1.5rem;
    max-width: 100%;
  }
  
  .summary-total-value {
    font-size: 2.5rem;
  }
  
  .summary-stats-row {
    grid-template-columns: 1fr;
    gap: 1rem;
  }
  
  .summary-stat-box {
    padding: 1.5rem 1rem;
  }
  
  .summary-stat-value {
    font-size: 2rem;
  }
  
  .stats-grid {
    grid-template-columns: 1fr;
    gap: 1.25rem;
  }
  
  .chart-section,
  .table-section {
    padding: 1.5rem;
  }
  
  .table-wrapper {
    font-size: 0.875rem;
  }
  
  th, td {
    padding: 0.75rem 0.5rem;
  }
}
</style>