<script setup>
import { ref, computed, watchEffect } from 'vue'
import { getCampaignData } from '@/data/campaigns'
import { fetchToolforgeCampaignData } from '@/services/api'
import { useCatalogStore } from '@/stores/catalog'

const props = defineProps({
  slug: { type: String, required: true },
})

const catalog = useCatalogStore()
const apiData = ref(null)
const loading = ref(false)

watchEffect(async () => {
  const slug = props.slug
  const cached = catalog.getCachedCampaignData(slug)
  const staticData = getCampaignData(slug)
  apiData.value = cached ?? null
  loading.value = false
  try {
    const data = await fetchToolforgeCampaignData(slug)
    apiData.value = data
    catalog.setCampaignDataCache(slug, data)
  } catch (_) {
    if (!cached && !staticData) loading.value = false
  }
})

const campaignData = computed(() => apiData.value || getCampaignData(props.slug))

const allYears = computed(() => {
  const data = campaignData.value
  if (!data?.years) return []
  return [...data.years].sort((a, b) => a.year - b.year)
})

const yearRange = computed(() => {
  if (!allYears.value.length) return { min: 2010, max: 2026 }
  const years = allYears.value.map((y) => y.year)
  return { min: Math.min(...years), max: Math.max(...years) }
})

const filterYearFrom = ref(null)
const filterYearTo = ref(null)
const metricFilter = ref('all')
const selectedCountry = ref('')
const countrySearchQuery = ref('')
const countryDropdownOpen = ref(false)

const METRIC_OPTIONS = [
  { key: 'all', label: 'All metrics' },
  { key: 'uploads', label: 'Uploads only' },
  { key: 'images_used', label: 'Images Used only' },
  { key: 'uploaders', label: 'Uploaders only' },
  { key: 'new_uploaders', label: 'New Uploaders only' },
]

// Extract all unique country names across every year
const allCountries = computed(() => {
  const names = new Set()
  for (const y of allYears.value) {
    const rows = y.country_rows ?? y.country_stats ?? []
    for (const r of rows) {
      const name = r.country ?? r.name
      if (name) names.add(name)
    }
  }
  return [...names].sort()
})

const filteredCountryList = computed(() => {
  if (!countrySearchQuery.value) return allCountries.value
  const q = countrySearchQuery.value.toLowerCase()
  return allCountries.value.filter((c) => c.toLowerCase().includes(q))
})

function selectCountry(c) {
  selectedCountry.value = c
  countrySearchQuery.value = ''
  countryDropdownOpen.value = false
}

function clearCountry() {
  selectedCountry.value = ''
  countrySearchQuery.value = ''
}

// Helper: pull a country's row from a year entry
function getCountryRow(yearEntry, countryName) {
  const rows = yearEntry.country_rows ?? yearEntry.country_stats ?? []
  return rows.find((r) => (r.country ?? r.name) === countryName)
}

// When a country is selected, project year-level data to that country's numbers
const yearFilteredByCountry = computed(() => {
  if (!selectedCountry.value) return allYears.value
  return allYears.value.map((y) => {
    const cr = getCountryRow(y, selectedCountry.value)
    if (!cr) return null
    return {
      year: y.year,
      countries: 1,
      uploads: cr.images ?? cr.uploads ?? 0,
      images_used: cr.images_used ?? 0,
      images_used_pct: cr.images_used_pct ?? null,
      uploaders: cr.uploaders ?? 0,
      new_uploaders: cr.new_uploaders ?? 0,
      new_uploaders_pct: cr.new_uploaders_pct ?? null,
    }
  }).filter(Boolean)
})

const chronologicalYears = computed(() => {
  const from = filterYearFrom.value ?? yearRange.value.min
  const to = filterYearTo.value ?? yearRange.value.max
  return yearFilteredByCountry.value.filter((y) => y.year >= from && y.year <= to)
})

const sortedYears = computed(() => [...chronologicalYears.value].reverse())

const totals = computed(() => {
  const y = chronologicalYears.value
  return {
    uploads: y.reduce((s, r) => s + (r.uploads || 0), 0),
    countries: selectedCountry.value ? 1 : Math.max(0, ...y.map(r => r.countries || 0)),
    uploaders: y.reduce((s, r) => s + (r.uploaders || 0), 0),
    years: y.length,
  }
})

const formatNumber = (value) => (value != null ? value.toLocaleString() : '—')
const formatPercent = (value) => (value != null ? `${value}%` : '—')

const ALL_CHART_SERIES = [
  { key: 'uploads', label: 'Uploads', color: '#10b981' },
  { key: 'images_used', label: 'Images Used', color: '#86efac' },
  { key: 'uploaders', label: 'Uploaders', color: '#2563eb' },
  { key: 'new_uploaders', label: 'New Uploaders', color: '#93c5fd' },
]

const CHART_SERIES = computed(() => {
  if (metricFilter.value === 'all') return ALL_CHART_SERIES
  return ALL_CHART_SERIES.filter((s) => s.key === metricFilter.value)
})

const chartPad = { top: 30, right: 20, bottom: 50, left: 60 }
const chartW = 960
const chartH = 340
const innerW = chartW - chartPad.left - chartPad.right
const innerH = chartH - chartPad.top - chartPad.bottom

const chartMaxVal = computed(() => {
  let max = 0
  for (const y of chronologicalYears.value) {
    for (const s of CHART_SERIES.value) {
      if ((y[s.key] || 0) > max) max = y[s.key]
    }
  }
  const nice = Math.ceil(max / 10000) * 10000
  return nice || 10000
})

const yTicks = computed(() => {
  const m = chartMaxVal.value
  const step = m / 5
  return Array.from({ length: 6 }, (_, i) => Math.round(i * step))
})

function barX(yearIdx, seriesIdx) {
  const n = chronologicalYears.value.length
  const groupW = innerW / n
  const bw = groupW * 0.7 / CHART_SERIES.value.length
  const groupStart = chartPad.left + yearIdx * groupW + groupW * 0.15
  return groupStart + seriesIdx * bw
}

function barW() {
  const n = chronologicalYears.value.length
  const groupW = innerW / n
  return Math.max(4, groupW * 0.7 / CHART_SERIES.value.length)
}

function barY(value) {
  return chartPad.top + innerH - (value / chartMaxVal.value) * innerH
}

function barHeight(value) {
  return (value / chartMaxVal.value) * innerH
}

function yearLabelX(yearIdx) {
  const n = chronologicalYears.value.length
  const groupW = innerW / n
  return chartPad.left + yearIdx * groupW + groupW / 2
}

function formatAxis(v) {
  if (v >= 1000) return `${Math.round(v / 1000)}k`
  return v
}

function yearLink(year) {
  const base = `/${props.slug}/${year}`
  return selectedCountry.value
    ? { path: base, query: { country: selectedCountry.value } }
    : base
}
</script>

<template>
  <div class="page">
    <div v-if="loading" class="loading-state">
      <div class="spinner"></div>
      <p>Loading campaign data&hellip;</p>
    </div>

    <template v-else-if="campaignData">
      <div class="page-inner">
        <!-- Breadcrumb -->
        <nav class="breadcrumb" aria-label="Breadcrumb">
          <router-link to="/">Home</router-link>
          <span class="sep">/</span>
          <span class="current">{{ campaignData.campaign_name }}</span>
        </nav>

        <!-- Hero -->
        <header class="page-hero">
          <h1 class="page-title">{{ campaignData.campaign_name }}</h1>
          <p class="page-subtitle">Participation, uploads, and usage across Wikimedia wikis &mdash; explore by year below.</p>
        </header>

        <!-- Key Stats -->
        <section class="stats-row">
          <div class="stat-card stat-card--accent">
            <span class="stat-value">{{ formatNumber(totals.uploads) }}</span>
            <span class="stat-label">Total Uploads</span>
          </div>
          <div class="stat-card stat-card--green">
            <span class="stat-value">{{ totals.years }}</span>
            <span class="stat-label">Editions</span>
          </div>
          <div class="stat-card stat-card--purple">
            <span class="stat-value">{{ formatNumber(totals.uploaders) }}</span>
            <span class="stat-label">Uploaders</span>
          </div>
          <div class="stat-card stat-card--orange">
            <span class="stat-value">{{ totals.countries }}</span>
            <span class="stat-label">Countries (max)</span>
          </div>
        </section>

        <!-- Year Pills -->
        <section class="years-section">
          <h2 class="section-heading">Explore by Year</h2>
          <div class="year-pills">
            <router-link
              v-for="y in sortedYears"
              :key="y.year"
              :to="yearLink(y.year)"
              class="year-pill"
            >{{ y.year }}</router-link>
          </div>
        </section>

        <!-- Filters -->
        <section class="filter-section">
          <div class="filter-bar">
            <div class="filter-group">
              <label class="filter-label">From</label>
              <select v-model.number="filterYearFrom" class="filter-select">
                <option :value="null">{{ yearRange.min }}</option>
                <option v-for="y in allYears" :key="y.year" :value="y.year">{{ y.year }}</option>
              </select>
            </div>
            <div class="filter-group">
              <label class="filter-label">To</label>
              <select v-model.number="filterYearTo" class="filter-select">
                <option :value="null">{{ yearRange.max }}</option>
                <option v-for="y in allYears" :key="y.year" :value="y.year">{{ y.year }}</option>
              </select>
            </div>
            <div class="filter-group filter-group--country">
              <label class="filter-label">Country</label>
              <div class="country-picker" @mouseleave="countryDropdownOpen = false">
                <div class="country-picker-input" @click="countryDropdownOpen = !countryDropdownOpen">
                  <span v-if="selectedCountry" class="country-selected">
                    {{ selectedCountry }}
                    <button class="country-clear" @click.stop="clearCountry" title="Clear">&times;</button>
                  </span>
                  <input
                    v-else
                    v-model="countrySearchQuery"
                    type="text"
                    class="country-search"
                    placeholder="All countries"
                    @focus="countryDropdownOpen = true"
                    @input="countryDropdownOpen = true"
                  />
                </div>
                <ul v-if="countryDropdownOpen && filteredCountryList.length" class="country-dropdown">
                  <li
                    v-for="c in filteredCountryList"
                    :key="c"
                    class="country-option"
                    :class="{ active: selectedCountry === c }"
                    @click="selectCountry(c)"
                  >{{ c }}</li>
                </ul>
              </div>
            </div>
            <div class="filter-group">
              <label class="filter-label">Metric</label>
              <select v-model="metricFilter" class="filter-select">
                <option v-for="o in METRIC_OPTIONS" :key="o.key" :value="o.key">{{ o.label }}</option>
              </select>
            </div>
            <span v-if="selectedCountry || chronologicalYears.length !== allYears.length" class="filter-count">
              <template v-if="selectedCountry">{{ selectedCountry }} &middot; </template>
              {{ chronologicalYears.length }} year{{ chronologicalYears.length !== 1 ? 's' : '' }}
            </span>
          </div>
        </section>

        <!-- Yearly Chart -->
        <section v-if="chronologicalYears.length" class="chart-section">
          <h2 class="section-heading">Yearly Overview</h2>
          <div class="chart-legend">
            <span v-for="s in CHART_SERIES" :key="s.key" class="legend-item">
              <span class="legend-dot" :style="{ background: s.color }"></span>
              {{ s.label }}
            </span>
          </div>
          <div class="chart-scroll">
            <svg
              :viewBox="`0 0 ${chartW} ${chartH}`"
              preserveAspectRatio="xMidYMid meet"
              class="bar-chart-svg"
            >
              <!-- Grid lines -->
              <line
                v-for="t in yTicks" :key="`g-${t}`"
                :x1="chartPad.left" :x2="chartW - chartPad.right"
                :y1="barY(t)" :y2="barY(t)"
                stroke="#e2e8f0" stroke-width="1"
              />
              <!-- Y-axis labels -->
              <text
                v-for="t in yTicks" :key="`yl-${t}`"
                :x="chartPad.left - 8" :y="barY(t) + 4"
                text-anchor="end" class="axis-text"
              >{{ formatAxis(t) }}</text>
              <!-- Bars -->
              <template v-for="(yr, yi) in chronologicalYears" :key="yr.year">
                <rect
                  v-for="(s, si) in CHART_SERIES" :key="`${yr.year}-${s.key}`"
                  :x="barX(yi, si)" :y="barY(yr[s.key] || 0)"
                  :width="barW()" :height="barHeight(yr[s.key] || 0)"
                  :fill="s.color" rx="2"
                >
                  <title>{{ yr.year }} {{ s.label }}: {{ formatNumber(yr[s.key]) }}</title>
                </rect>
              </template>
              <!-- X-axis labels -->
              <text
                v-for="(yr, yi) in chronologicalYears" :key="`xl-${yr.year}`"
                :x="yearLabelX(yi)" :y="chartH - 12"
                text-anchor="middle" class="axis-text"
              >{{ yr.year }}</text>
            </svg>
          </div>
        </section>

        <!-- Table -->
        <section class="table-section">
          <h2 class="section-heading">Yearly Breakdown</h2>
          <div class="table-wrap">
            <table class="data-table">
              <thead>
                <tr>
                  <th>Year</th>
                  <th class="th-num">Countries</th>
                  <th class="th-num">Uploads</th>
                  <th class="th-num">Images Used</th>
                  <th class="th-num">Uploaders</th>
                  <th class="th-num">New Uploaders</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="row in sortedYears" :key="row.year">
                  <td class="td-year">
                    <router-link :to="yearLink(row.year)" class="year-link">{{ row.year }}</router-link>
                  </td>
                  <td class="td-num">{{ formatNumber(row.countries) }}</td>
                  <td class="td-num">{{ formatNumber(row.uploads) }}</td>
                  <td class="td-num">
                    {{ formatNumber(row.images_used) }}
                    <span v-if="row.images_used_pct != null" class="pct">({{ formatPercent(row.images_used_pct) }})</span>
                  </td>
                  <td class="td-num">{{ formatNumber(row.uploaders) }}</td>
                  <td class="td-num">
                    {{ formatNumber(row.new_uploaders) }}
                    <span v-if="row.new_uploaders_pct != null" class="pct">({{ formatPercent(row.new_uploaders_pct) }})</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
          <p class="meta-text">{{ apiData ? 'Live data from Toolforge' : 'Static data' }}{{ campaignData.updated ? ` · Updated ${campaignData.updated}` : '' }}</p>
        </section>
      </div>
    </template>

    <div v-else class="not-found">
      <p>Campaign not found.</p>
      <router-link to="/">Back to Home</router-link>
    </div>
  </div>
</template>

<style scoped>
.page { min-height: 100vh; }

.page-inner {
  max-width: 1100px;
  margin: 0 auto;
  padding: 2rem;
}

/* Breadcrumb */
.breadcrumb {
  font-size: 0.875rem;
  margin-bottom: 2rem;
  color: var(--text-muted);
}
.breadcrumb a { color: var(--color-accent); text-decoration: none; font-weight: 500; }
.breadcrumb a:hover { text-decoration: underline; }
.sep { margin: 0 0.5rem; }
.current { color: var(--text-primary); font-weight: 600; }

/* Hero */
.page-hero { margin-bottom: 2.5rem; }
.page-title {
  margin: 0 0 0.5rem;
  font-size: clamp(2rem, 5vw, 2.75rem);
  font-weight: 800;
  letter-spacing: -0.03em;
  color: var(--text-primary);
}
.page-subtitle {
  margin: 0;
  font-size: 1.0625rem;
  color: var(--text-secondary);
  max-width: 540px;
  line-height: 1.6;
}

/* Stats */
.stats-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 1rem;
  margin-bottom: 2.5rem;
}

.stat-card {
  display: flex;
  flex-direction: column;
  gap: 0.375rem;
  padding: 1.5rem;
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-left: 4px solid var(--color-accent);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-sm);
}

.stat-card--accent { border-left-color: var(--color-accent); }
.stat-card--green { border-left-color: var(--color-green); }
.stat-card--purple { border-left-color: var(--color-purple); }
.stat-card--orange { border-left-color: var(--color-orange); }

.stat-value {
  font-size: 2rem;
  font-weight: 800;
  color: var(--text-primary);
  font-variant-numeric: tabular-nums;
  letter-spacing: -0.03em;
  line-height: 1.1;
}

.stat-label {
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--text-secondary);
}

/* Year pills */
.years-section { margin-bottom: 2.5rem; }

.section-heading {
  margin: 0 0 1rem;
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--text-primary);
}

.year-pills {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.year-pill {
  padding: 0.5rem 1.25rem;
  border: 2px solid var(--border-color);
  border-radius: 999px;
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--text-secondary);
  text-decoration: none;
  transition: all 0.15s;
  background: var(--bg-card);
}

.year-pill:hover {
  border-color: var(--color-accent);
  color: var(--color-accent);
  text-decoration: none;
  background: #eff6ff;
}

/* Filters */
.filter-section { margin-bottom: 1.5rem; }

.filter-bar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.75rem;
}

.filter-group {
  display: flex;
  align-items: center;
  gap: 0.375rem;
}

.filter-label {
  font-size: 0.75rem;
  font-weight: 600;
  color: var(--text-muted);
  text-transform: uppercase;
  letter-spacing: 0.04em;
  white-space: nowrap;
}

.filter-select {
  padding: 0.5rem 0.75rem;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  font-size: 0.875rem;
  background: var(--bg-card);
  color: var(--text-primary);
  cursor: pointer;
}
.filter-select:focus { outline: none; border-color: var(--color-accent); }

.filter-count {
  font-size: 0.8125rem;
  color: var(--text-muted);
  font-weight: 500;
}

/* Country picker */
.filter-group--country { position: relative; }

.country-picker { position: relative; min-width: 180px; }

.country-picker-input {
  display: flex;
  align-items: center;
  padding: 0.375rem 0.75rem;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  background: var(--bg-card);
  cursor: pointer;
  min-height: 34px;
}

.country-search {
  border: none;
  outline: none;
  background: transparent;
  font-size: 0.875rem;
  color: var(--text-primary);
  width: 100%;
}
.country-search::placeholder { color: var(--text-muted); }

.country-selected {
  display: flex;
  align-items: center;
  gap: 0.375rem;
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--text-primary);
}

.country-clear {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 18px;
  height: 18px;
  border: none;
  border-radius: 50%;
  background: var(--bg-secondary, #f1f5f9);
  color: var(--text-muted);
  font-size: 0.875rem;
  line-height: 1;
  cursor: pointer;
  padding: 0;
}
.country-clear:hover { background: #fecaca; color: #ef4444; }

.country-dropdown {
  position: absolute;
  top: calc(100% + 4px);
  left: 0;
  width: 100%;
  min-width: 200px;
  max-height: 240px;
  overflow-y: auto;
  background: var(--bg-card, #fff);
  border: 1px solid var(--border-color);
  border-radius: 8px;
  box-shadow: 0 8px 24px rgba(0,0,0,0.12);
  z-index: 50;
  list-style: none;
  margin: 0;
  padding: 0.25rem 0;
}

.country-option {
  padding: 0.5rem 0.75rem;
  font-size: 0.875rem;
  color: var(--text-primary);
  cursor: pointer;
  transition: background 0.1s;
}
.country-option:hover { background: var(--bg-hover, #f3f4f6); }
.country-option.active { background: #eff6ff; color: var(--color-accent); font-weight: 600; }

/* Chart */
.chart-section {
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  padding: 1.5rem 2rem;
  margin-bottom: 2.5rem;
  box-shadow: var(--shadow-sm);
}

.chart-legend {
  display: flex;
  flex-wrap: wrap;
  gap: 1.25rem;
  margin-bottom: 1rem;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 0.375rem;
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--text-secondary);
}

.legend-dot {
  width: 10px;
  height: 10px;
  border-radius: 3px;
  flex-shrink: 0;
}

.chart-scroll {
  overflow-x: auto;
}

.bar-chart-svg {
  display: block;
  width: 100%;
  height: auto;
  min-width: 700px;
}

.bar-chart-svg rect {
  transition: opacity 0.15s;
  cursor: pointer;
}

.bar-chart-svg rect:hover {
  opacity: 0.8;
}

.axis-text {
  font-size: 11px;
  fill: var(--text-muted, #94a3b8);
  font-weight: 500;
}

/* Table */
.table-section { margin-bottom: 2rem; }

.table-wrap {
  overflow-x: auto;
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  background: var(--bg-card);
  box-shadow: var(--shadow-sm);
}

.data-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.9375rem;
}

.data-table thead tr {
  background: var(--bg-secondary);
  border-bottom: 2px solid var(--border-color);
}

.data-table th {
  padding: 0.875rem 1.25rem;
  text-align: left;
  font-weight: 700;
  color: var(--text-secondary);
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.th-num { text-align: right; }

.data-table td {
  padding: 0.875rem 1.25rem;
  border-bottom: 1px solid var(--border-color);
  color: var(--text-primary);
}

.data-table tbody tr:last-child td { border-bottom: none; }
.data-table tbody tr:hover { background: var(--bg-hover); }

.td-year { font-weight: 700; }
.year-link { color: var(--color-accent); text-decoration: none; font-weight: 700; }
.year-link:hover { text-decoration: underline; }

.td-num {
  text-align: right;
  font-variant-numeric: tabular-nums;
  font-weight: 600;
}

.pct {
  color: var(--text-muted);
  font-weight: 400;
  margin-left: 0.25rem;
}

.meta-text {
  margin: 0.75rem 0 0;
  font-size: 0.8125rem;
  color: var(--text-muted);
}

.loading-state {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  min-height: 40vh;
  gap: 1rem;
  color: var(--text-secondary);
}

.spinner {
  width: 36px;
  height: 36px;
  border: 3px solid var(--border-color);
  border-top-color: var(--color-accent);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin { to { transform: rotate(360deg); } }

.not-found {
  max-width: 1100px;
  margin: 0 auto;
  padding: 4rem 2rem;
  text-align: center;
}

@media (max-width: 768px) {
  .page-inner { padding: 1.5rem; }
  .stats-row { grid-template-columns: 1fr 1fr; }
  .stat-value { font-size: 1.5rem; }
  .data-table th, .data-table td { padding: 0.625rem 0.875rem; font-size: 0.875rem; }
  .filter-bar { flex-direction: column; align-items: stretch; }
}
</style>
