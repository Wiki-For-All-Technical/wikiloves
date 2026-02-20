<script setup>
import { ref, computed, watchEffect } from 'vue'
import { useRoute } from 'vue-router'
import { getCampaignData } from '@/data/campaigns'
import { fetchToolforgeCampaignData } from '@/services/api'
import { useCatalogStore } from '@/stores/catalog'
import CountryCumulativeChart from '@/components/CountryCumulativeChart.vue'

const props = defineProps({
  slug: { type: String, required: true },
  year: { type: [Number, String], required: true },
})

const route = useRoute()

const catalog = useCatalogStore()
const yearNum = computed(() => parseInt(props.year, 10))

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

const yearData = computed(() => {
  const data = campaignData.value
  if (!data?.years) return null
  return data.years.find((y) => y.year === yearNum.value) ?? null
})

const campaignName = computed(() => campaignData.value?.campaign_name ?? 'Wiki Loves')
const campaignPath = computed(() => `/${props.slug}`)

const countryRows = computed(() => {
  const y = yearData.value
  if (!y?.country_rows?.length) return null
  return y.country_rows
})

const fallbackRow = computed(() => {
  const y = yearData.value
  if (!y || countryRows.value?.length) return null
  return {
    country: 'All countries',
    images: y.uploads ?? 0,
    images_used: y.images_used ?? 0,
    images_used_pct: y.images_used_pct ?? null,
    uploaders: y.uploaders ?? 0,
    new_uploaders: y.new_uploaders ?? 0,
    new_uploaders_pct: y.new_uploaders_pct ?? null,
  }
})

const rawTableRows = computed(() => {
  if (countryRows.value?.length) return countryRows.value
  if (fallbackRow.value) return [fallbackRow.value]
  return []
})

// ── Filters ─────────────────────────────────────────────────────────────────
const searchQuery = ref('')
const sortKey = ref('images')
const sortDir = ref('desc')
const minUploads = ref(0)
const _initialCountry = route.query.country
const selectedCountries = ref(_initialCountry ? [_initialCountry] : [])
const countrySearchTerm = ref('')
const countryPickerOpen = ref(false)

const SORT_OPTIONS = [
  { key: 'images', label: 'Images' },
  { key: 'images_used', label: 'Images Used' },
  { key: 'uploaders', label: 'Uploaders' },
  { key: 'new_uploaders', label: 'New Uploaders' },
]

// All unique countries in this year's data
const allCountriesInYear = computed(() => {
  return rawTableRows.value.map((r) => r.country).filter(Boolean).sort()
})

const filteredPickerCountries = computed(() => {
  const q = countrySearchTerm.value.toLowerCase()
  const list = allCountriesInYear.value.filter((c) => !selectedCountries.value.includes(c))
  return q ? list.filter((c) => c.toLowerCase().includes(q)) : list
})

function addCountry(c) {
  if (!selectedCountries.value.includes(c)) {
    selectedCountries.value = [...selectedCountries.value, c]
  }
  countrySearchTerm.value = ''
  countryPickerOpen.value = false
}

function removeCountry(c) {
  selectedCountries.value = selectedCountries.value.filter((x) => x !== c)
}

function clearAllCountries() {
  selectedCountries.value = []
}

function toggleSort(key) {
  if (sortKey.value === key) {
    sortDir.value = sortDir.value === 'desc' ? 'asc' : 'desc'
  } else {
    sortKey.value = key
    sortDir.value = 'desc'
  }
}

const tableRows = computed(() => {
  let rows = [...rawTableRows.value]
  if (selectedCountries.value.length) {
    rows = rows.filter((r) => selectedCountries.value.includes(r.country))
  }
  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase()
    rows = rows.filter((r) => r.country?.toLowerCase().includes(q))
  }
  if (minUploads.value > 0) {
    rows = rows.filter((r) => (r.images ?? 0) >= minUploads.value)
  }
  rows.sort((a, b) => {
    const av = a[sortKey.value] ?? 0
    const bv = b[sortKey.value] ?? 0
    return sortDir.value === 'desc' ? bv - av : av - bv
  })
  return rows
})

// Dynamic stat totals based on filter
const filteredStats = computed(() => {
  if (!selectedCountries.value.length) return null
  const rows = tableRows.value
  return {
    uploads: rows.reduce((s, r) => s + (r.images ?? 0), 0),
    images_used: rows.reduce((s, r) => s + (r.images_used ?? 0), 0),
    uploaders: rows.reduce((s, r) => s + (r.uploaders ?? 0), 0),
    new_uploaders: rows.reduce((s, r) => s + (r.new_uploaders ?? 0), 0),
    countries: rows.length,
  }
})

const formatNumber = (v) => (v != null ? v.toLocaleString() : '—')
const formatPercent = (v) => (v != null ? `${v}%` : '—')

const barColors = [
  '#2563eb', '#10b981', '#8b5cf6', '#f59e0b', '#ef4444', '#06b6d4', '#ec4899',
  '#65a30d', '#4f46e5', '#ea580c', '#0d9488', '#be185d', '#84cc16', '#7c3aed',
]
const barColor = (index) => barColors[index % barColors.length]
</script>

<template>
  <div class="page">
    <div v-if="loading" class="loading-state">
      <div class="spinner"></div>
      <p>Loading year data&hellip;</p>
    </div>

    <template v-else-if="yearData">
      <div class="page-inner">
        <!-- Breadcrumb -->
        <nav class="breadcrumb" aria-label="Breadcrumb">
          <router-link to="/">Home</router-link>
          <span class="sep">/</span>
          <router-link :to="campaignPath">{{ campaignName }}</router-link>
          <span class="sep">/</span>
          <span class="current">{{ yearNum }}</span>
        </nav>

        <!-- Hero -->
        <header class="page-hero">
          <h1 class="page-title">{{ campaignName }} {{ yearNum }}</h1>
          <p class="page-subtitle">Tool Labs &ndash; Tools for Wiki Loves Photo Competitions</p>
        </header>

        <!-- Stats -->
        <section class="stats-row">
          <div class="stat-card stat-card--accent">
            <span class="stat-value">{{ formatNumber(filteredStats ? filteredStats.uploads : yearData.uploads) }}</span>
            <span class="stat-label">Total Images</span>
          </div>
          <div class="stat-card stat-card--green">
            <span class="stat-value">{{ formatNumber(filteredStats ? filteredStats.images_used : yearData.images_used) }}</span>
            <span class="stat-label">Images Used</span>
            <span v-if="!filteredStats && yearData.images_used_pct != null" class="stat-meta">({{ yearData.images_used_pct }}%)</span>
          </div>
          <div class="stat-card stat-card--purple">
            <span class="stat-value">{{ formatNumber(filteredStats ? filteredStats.countries : yearData.countries) }}</span>
            <span class="stat-label">Countries</span>
          </div>
          <div class="stat-card stat-card--orange">
            <span class="stat-value">{{ formatNumber(filteredStats ? filteredStats.uploaders : yearData.uploaders) }}</span>
            <span class="stat-label">Uploaders</span>
          </div>
          <div class="stat-card stat-card--teal">
            <span class="stat-value">{{ formatNumber(filteredStats ? filteredStats.new_uploaders : yearData.new_uploaders) }}</span>
            <span class="stat-label">New Uploaders</span>
            <span v-if="!filteredStats && yearData.new_uploaders_pct != null" class="stat-meta">({{ yearData.new_uploaders_pct }}%)</span>
          </div>
        </section>

        <!-- Chart -->
        <section class="chart-section">
          <h2 class="section-heading">Cumulative Uploads</h2>
          <div class="chart-wrap">
            <CountryCumulativeChart
              v-if="countryRows?.length"
              :country-rows="countryRows"
              :colors="barColors"
              :height="280"
            />
            <svg
              v-else
              class="placeholder-graph"
              viewBox="0 0 400 180"
              preserveAspectRatio="none"
              aria-hidden="true"
            >
              <defs>
                <linearGradient id="yearGrad" x1="0%" y1="0%" x2="0%" y2="100%">
                  <stop offset="0%" stop-color="#2563eb" stop-opacity="0.2" />
                  <stop offset="100%" stop-color="#2563eb" stop-opacity="0" />
                </linearGradient>
              </defs>
              <line v-for="i in 4" :key="i" x1="40" :y1="40*i" x2="380" :y2="40*i" stroke="#e2e8f0" stroke-width="1" />
              <polyline points="40,160 120,120 200,80 280,45 380,20" fill="none" stroke="#2563eb" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round" />
              <polygon points="40,160 120,120 200,80 280,45 380,20 380,160 40,160" fill="url(#yearGrad)" />
            </svg>
          </div>
        </section>

        <!-- Country Table -->
        <section class="table-section">
          <h2 class="section-heading">Country Breakdown</h2>

          <!-- Filters -->
          <div class="filter-bar">
            <div class="filter-search">
              <svg class="filter-icon" viewBox="0 0 20 20" fill="currentColor" width="16" height="16">
                <path fill-rule="evenodd" d="M9 3.5a5.5 5.5 0 100 11 5.5 5.5 0 000-11zM2 9a7 7 0 1112.45 4.38l4.09 4.08a.75.75 0 11-1.06 1.06l-4.08-4.09A7 7 0 012 9z" clip-rule="evenodd"/>
              </svg>
              <input v-model="searchQuery" type="text" placeholder="Search countries..." class="filter-input" />
            </div>

            <!-- Country multi-select -->
            <div class="filter-group filter-group--country">
              <label class="filter-label">Countries</label>
              <div class="country-multi" @mouseleave="countryPickerOpen = false">
                <div class="country-multi-input" @click="countryPickerOpen = !countryPickerOpen">
                  <span v-for="c in selectedCountries" :key="c" class="country-tag">
                    {{ c }}
                    <button class="tag-remove" @click.stop="removeCountry(c)">&times;</button>
                  </span>
                  <input
                    v-model="countrySearchTerm"
                    type="text"
                    class="country-type-input"
                    :placeholder="selectedCountries.length ? '' : 'Filter countries...'"
                    @focus="countryPickerOpen = true"
                    @input="countryPickerOpen = true"
                  />
                </div>
                <button v-if="selectedCountries.length" class="country-clear-all" @click.stop="clearAllCountries" title="Clear all">&times;</button>
                <ul v-if="countryPickerOpen && filteredPickerCountries.length" class="country-dropdown">
                  <li
                    v-for="c in filteredPickerCountries"
                    :key="c"
                    class="country-option"
                    @click="addCountry(c)"
                  >{{ c }}</li>
                </ul>
              </div>
            </div>

            <div class="filter-group">
              <label class="filter-label">Min uploads</label>
              <input v-model.number="minUploads" type="number" min="0" step="100" class="filter-number" />
            </div>
            <div class="filter-group">
              <label class="filter-label">Sort by</label>
              <select v-model="sortKey" class="filter-select">
                <option v-for="o in SORT_OPTIONS" :key="o.key" :value="o.key">{{ o.label }}</option>
              </select>
              <button class="sort-dir-btn" :title="sortDir === 'desc' ? 'Descending' : 'Ascending'" @click="sortDir = sortDir === 'desc' ? 'asc' : 'desc'">
                {{ sortDir === 'desc' ? '↓' : '↑' }}
              </button>
            </div>
            <span v-if="rawTableRows.length !== tableRows.length" class="filter-count">
              {{ tableRows.length }} of {{ rawTableRows.length }}
            </span>
          </div>

          <div class="table-wrap">
            <table class="data-table">
              <thead>
                <tr>
                  <th class="th-bar"></th>
                  <th class="th-rank">#</th>
                  <th>Country</th>
                  <th class="th-num th-sortable" :class="{ active: sortKey === 'images' }" @click="toggleSort('images')">Images <span class="sort-arrow">{{ sortKey === 'images' ? (sortDir === 'desc' ? '↓' : '↑') : '' }}</span></th>
                  <th class="th-num th-sortable" :class="{ active: sortKey === 'images_used' }" @click="toggleSort('images_used')">Images Used <span class="sort-arrow">{{ sortKey === 'images_used' ? (sortDir === 'desc' ? '↓' : '↑') : '' }}</span></th>
                  <th class="th-num th-sortable" :class="{ active: sortKey === 'uploaders' }" @click="toggleSort('uploaders')">Uploaders <span class="sort-arrow">{{ sortKey === 'uploaders' ? (sortDir === 'desc' ? '↓' : '↑') : '' }}</span></th>
                  <th class="th-num th-sortable" :class="{ active: sortKey === 'new_uploaders' }" @click="toggleSort('new_uploaders')">New Uploaders <span class="sort-arrow">{{ sortKey === 'new_uploaders' ? (sortDir === 'desc' ? '↓' : '↑') : '' }}</span></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(row, i) in tableRows" :key="row.country">
                  <td class="td-bar">
                    <span class="color-dot" :style="{ background: barColor(i) }"></span>
                  </td>
                  <td class="td-rank">{{ i + 1 }}</td>
                  <td class="td-country">
                    <router-link :to="`/${slug}/${yearNum}/${row.country}`" class="country-link">{{ row.country }}</router-link>
                  </td>
                  <td class="td-num">{{ formatNumber(row.images) }}</td>
                  <td class="td-num">
                    {{ formatNumber(row.images_used) }}
                    <span v-if="row.images_used_pct != null" class="pct">({{ row.images_used_pct }}%)</span>
                  </td>
                  <td class="td-num">{{ formatNumber(row.uploaders) }}</td>
                  <td class="td-num">
                    {{ formatNumber(row.new_uploaders) }}
                    <span v-if="row.new_uploaders_pct != null" class="pct">({{ row.new_uploaders_pct }}%)</span>
                  </td>
                </tr>
                <tr v-if="!tableRows.length">
                  <td colspan="7" class="td-empty">No countries match the current filters.</td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>
      </div>
    </template>

    <div v-else class="not-found">
      <p>No data for this year.</p>
      <router-link :to="campaignPath">Back to {{ campaignName }}</router-link>
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

.breadcrumb {
  font-size: 0.875rem;
  margin-bottom: 2rem;
  color: var(--text-muted);
}
.breadcrumb a { color: var(--color-accent); text-decoration: none; font-weight: 500; }
.breadcrumb a:hover { text-decoration: underline; }
.sep { margin: 0 0.5rem; }
.current { color: var(--text-primary); font-weight: 600; }

.page-hero { margin-bottom: 2rem; }
.page-title {
  margin: 0 0 0.375rem;
  font-size: clamp(1.75rem, 4vw, 2.5rem);
  font-weight: 800;
  letter-spacing: -0.03em;
  color: var(--text-primary);
}
.page-subtitle {
  margin: 0;
  font-size: 0.9375rem;
  color: var(--text-secondary);
}

/* Stats */
.stats-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
  gap: 1rem;
  margin-bottom: 2.5rem;
}

.stat-card {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  padding: 1.25rem 1.5rem;
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-left: 4px solid var(--color-accent);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-sm);
}

.stat-card--accent { border-left-color: var(--color-accent); }
.stat-card--green  { border-left-color: #10b981; }
.stat-card--purple { border-left-color: #8b5cf6; }
.stat-card--orange { border-left-color: #f59e0b; }
.stat-card--teal   { border-left-color: #14b8a6; }

.stat-value {
  font-size: 1.75rem;
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

.stat-meta {
  font-size: 0.75rem;
  color: var(--text-muted);
}

/* Chart */
.chart-section { margin-bottom: 2.5rem; }

.section-heading {
  margin: 0 0 1rem;
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--text-primary);
}

.chart-wrap {
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  padding: 1rem;
  box-shadow: var(--shadow-sm);
  overflow: hidden;
  min-height: 200px;
}

.placeholder-graph {
  width: 100%;
  height: 180px;
  display: block;
}

/* Filters */
.filter-bar {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 1rem;
}

.filter-search {
  position: relative;
  flex: 1;
  min-width: 180px;
  max-width: 300px;
}

.filter-icon {
  position: absolute;
  left: 0.75rem;
  top: 50%;
  transform: translateY(-50%);
  color: var(--text-muted);
  pointer-events: none;
}

.filter-input {
  width: 100%;
  padding: 0.5rem 0.75rem 0.5rem 2.25rem;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  font-size: 0.875rem;
  background: var(--bg-card);
  color: var(--text-primary);
}

.filter-input:focus { outline: none; border-color: var(--color-accent); box-shadow: 0 0 0 2px rgba(37,99,235,0.15); }

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

.filter-number {
  width: 90px;
  padding: 0.5rem 0.5rem;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  font-size: 0.875rem;
  background: var(--bg-card);
  color: var(--text-primary);
}
.filter-number:focus { outline: none; border-color: var(--color-accent); }

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

.sort-dir-btn {
  width: 32px;
  height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  background: var(--bg-card);
  color: var(--text-primary);
  font-size: 1rem;
  cursor: pointer;
  transition: all 0.15s;
}
.sort-dir-btn:hover { border-color: var(--color-accent); color: var(--color-accent); }

.filter-count {
  font-size: 0.8125rem;
  color: var(--text-muted);
  font-weight: 500;
}

/* Country multi-select */
.filter-group--country { position: relative; }

.country-multi {
  position: relative;
  display: flex;
  align-items: center;
  gap: 0.25rem;
}

.country-multi-input {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.25rem;
  min-width: 180px;
  max-width: 360px;
  padding: 0.25rem 0.5rem;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  background: var(--bg-card);
  cursor: text;
  min-height: 34px;
}

.country-tag {
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.125rem 0.5rem;
  background: #eff6ff;
  color: var(--color-accent);
  border-radius: 4px;
  font-size: 0.75rem;
  font-weight: 600;
  white-space: nowrap;
}

.tag-remove {
  border: none;
  background: none;
  color: inherit;
  font-size: 0.875rem;
  cursor: pointer;
  padding: 0;
  line-height: 1;
  opacity: 0.6;
}
.tag-remove:hover { opacity: 1; }

.country-type-input {
  border: none;
  outline: none;
  background: transparent;
  font-size: 0.8125rem;
  color: var(--text-primary);
  flex: 1;
  min-width: 80px;
}
.country-type-input::placeholder { color: var(--text-muted); }

.country-clear-all {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 22px;
  height: 22px;
  border: none;
  border-radius: 50%;
  background: var(--bg-secondary, #f1f5f9);
  color: var(--text-muted);
  font-size: 0.875rem;
  cursor: pointer;
  padding: 0;
  flex-shrink: 0;
}
.country-clear-all:hover { background: #fecaca; color: #ef4444; }

.country-dropdown {
  position: absolute;
  top: calc(100% + 4px);
  left: 0;
  width: 100%;
  min-width: 200px;
  max-height: 220px;
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

.th-sortable { cursor: pointer; user-select: none; transition: color 0.15s; }
.th-sortable:hover { color: var(--color-accent); }
.th-sortable.active { color: var(--color-accent); }
.sort-arrow { font-size: 0.75rem; margin-left: 0.125rem; }

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
  padding: 0.875rem 1rem;
  text-align: left;
  font-weight: 700;
  color: var(--text-secondary);
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}

.th-bar { width: 20px; padding: 0.5rem !important; }
.th-rank { width: 36px; text-align: center; }
.th-num { text-align: right; }

.data-table td {
  padding: 0.75rem 1rem;
  border-bottom: 1px solid var(--border-color);
  color: var(--text-primary);
}

.data-table tbody tr:last-child td { border-bottom: none; }
.data-table tbody tr:hover { background: var(--bg-hover); }

.td-bar { width: 20px; padding: 0.5rem !important; vertical-align: middle; }
.color-dot {
  display: inline-block;
  width: 10px; height: 10px;
  border-radius: 50%;
}
.td-rank { text-align: center; font-weight: 600; color: var(--text-muted); }
.td-country { font-weight: 600; }
.country-link { color: var(--color-accent); text-decoration: none; }
.country-link:hover { text-decoration: underline; }
.td-num { text-align: right; font-variant-numeric: tabular-nums; font-weight: 600; }
.pct { color: var(--text-muted); font-weight: 400; margin-left: 0.25rem; }

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
  color: var(--text-secondary);
}

.td-empty {
  text-align: center;
  padding: 2rem 1rem !important;
  color: var(--text-muted);
  font-style: italic;
}

@media (max-width: 768px) {
  .page-inner { padding: 1.5rem; }
  .stats-row { grid-template-columns: 1fr 1fr; }
  .stat-value { font-size: 1.35rem; }
  .data-table th, .data-table td { padding: 0.5rem 0.75rem; font-size: 0.875rem; }
  .filter-bar { flex-direction: column; align-items: stretch; }
  .filter-search { max-width: 100%; }
}
</style>
