<script setup>
import { computed, onMounted, watch, ref } from 'vue'
import { useRoute } from 'vue-router'
import { useCatalogStore } from '@/stores/catalog'
import { fetchToolforgeCountryUploaders } from '@/services/api'
import Breadcrumbs from '@/components/Breadcrumbs.vue'
import SkeletonLoader from '@/components/SkeletonLoader.vue'
import DailyUploadsChart from '@/components/DailyUploadsChart.vue'
import PieChart from '@/components/PieChart.vue'

const route = useRoute()
const catalog = useCatalogStore()

const loading = ref(false)
const error = ref(null)
const countryData = ref(null)
const uploaders = ref([])
const uploadersLoading = ref(false)
const uploadersTotal = ref(0)

const searchQuery = ref('')
const sortField = ref('uploads')
const sortDir = ref('desc')
const copiedWiki = ref(false)

const segment = computed(() => route.params.segment)
const year = computed(() => parseInt(route.params.year))
const country = computed(() => route.params.country)

const PIE_COLORS = [
  '#3b82f6', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6',
  '#06b6d4', '#ec4899', '#f97316', '#6366f1', '#14b8a6',
]

async function loadData() {
  loading.value = true
  error.value = null
  try {
    if (!catalog.navigation.length) {
      await catalog.loadNavigation()
    }
    const slug = catalog.resolveSegment(segment.value)
    if (!slug) { error.value = 'Campaign not found'; return }
    const data = await catalog.loadCampaignCountryDetail(slug, year.value, country.value)
    countryData.value = data
    loadUploaders(slug)
  } catch (err) {
    console.error('Error loading country detail:', err)
    error.value = err.message || 'Failed to load data'
  } finally {
    loading.value = false
  }
}

async function loadUploaders(slug) {
  uploadersLoading.value = true
  try {
    const data = await fetchToolforgeCountryUploaders(slug, year.value, country.value)
    if (data?.uploaders?.length) {
      uploaders.value = data.uploaders
      uploadersTotal.value = data.total_uploads || 0
    }
  } catch (e) {
    console.warn('Uploaders not available:', e.message)
  } finally {
    uploadersLoading.value = false
  }
}

onMounted(() => loadData())
watch(() => [route.params.segment, route.params.year, route.params.country], () => loadData(), { immediate: false })

// Computed stats
const activeDays = computed(() => countryData.value?.daily_stats?.length || 0)
const avgUploadsPerDay = computed(() => {
  const days = activeDays.value
  if (!days) return 0
  return Math.round((countryData.value?.total_uploads || 0) / days)
})

// Chart data
const dailyChartData = computed(() =>
  (countryData.value?.daily_stats || []).map(d => ({ date: d.date, count: d.uploads }))
)

const pieSegments = computed(() => {
  const top = uploaders.value.slice(0, 8)
  const topTotal = top.reduce((s, u) => s + u.uploads, 0)
  const rest = (uploadersTotal.value || countryData.value?.total_uploads || 0) - topTotal
  const segments = top.map((u, i) => ({
    label: u.username,
    value: u.uploads,
    color: PIE_COLORS[i % PIE_COLORS.length],
  }))
  if (rest > 0) segments.push({ label: 'Others', value: rest, color: '#cbd5e1' })
  return segments
})

// Uploaders table
const filteredUploaders = computed(() => {
  let list = [...uploaders.value]
  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase()
    list = list.filter(u => u.username.toLowerCase().includes(q))
  }
  list.sort((a, b) => {
    const va = a[sortField.value] || 0
    const vb = b[sortField.value] || 0
    return sortDir.value === 'desc' ? vb - va : va - vb
  })
  return list
})

function toggleSort(field) {
  if (sortField.value === field) {
    sortDir.value = sortDir.value === 'desc' ? 'asc' : 'desc'
  } else {
    sortField.value = field
    sortDir.value = 'desc'
  }
}

function sortIcon(field) {
  if (sortField.value !== field) return '↕'
  return sortDir.value === 'desc' ? '↓' : '↑'
}

function exportCSV() {
  const header = 'Rank,Username,Files Uploaded,Percentage\n'
  const rows = filteredUploaders.value.map((u, i) =>
    `${i + 1},"${u.username}",${u.uploads},${u.percentage}%`
  ).join('\n')
  const blob = new Blob([header + rows], { type: 'text/csv' })
  const url = URL.createObjectURL(blob)
  const a = document.createElement('a')
  a.href = url
  a.download = `${countryData.value?.campaign || 'campaign'}_${year.value}_${country.value}_uploaders.csv`
  a.click()
  URL.revokeObjectURL(url)
}

function copyWikitable() {
  const header = '{| class="wikitable sortable"\n|-\n! Rank !! Username !! Files !! %\n'
  const rows = filteredUploaders.value.map((u, i) =>
    `|-\n| ${i + 1} || [[User:${u.username}|${u.username}]] || ${u.uploads} || ${u.percentage}%`
  ).join('\n')
  navigator.clipboard.writeText(header + rows + '\n|}')
  copiedWiki.value = true
  setTimeout(() => { copiedWiki.value = false }, 2000)
}

function formatNum(num) {
  return new Intl.NumberFormat('en-US').format(num)
}

function getDailyUploadUrl(date, categoryName) {
  return `https://heritage.toolforge.org/tools/daily-uploads/daily-uploads.html?date=${date}&category=${encodeURIComponent(categoryName)}&load=true`
}

function getCommonsUrl(categoryName) {
  return `https://commons.wikimedia.org/wiki/Category:${categoryName}`
}

function getUserUrl(username) {
  return `https://commons.wikimedia.org/wiki/User:${encodeURIComponent(username)}`
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
      <button @click="$router.back()" class="back-btn">&larr; Go Back</button>
    </div>

    <div v-else-if="countryData" class="content">
      <!-- Header -->
      <header class="page-header">
        <h1>{{ countryData.campaign }} {{ countryData.year }} in {{ countryData.country }}</h1>
        <p class="subtitle">Tool Labs &ndash; Tools for Wiki Loves Photo Competitions</p>
        <p class="commons-link">
          <a :href="getCommonsUrl(countryData.category_name)">Category on Wikimedia Commons</a>
        </p>
        <p class="note">(All times are UTC.)</p>
      </header>

      <!-- Summary Stat Cards -->
      <section class="stat-cards">
        <div class="stat-card stat-card--blue">
          <div class="stat-card-body">
            <span class="stat-card-label">Total Images</span>
            <span class="stat-card-value">{{ formatNum(countryData.total_uploads) }}</span>
          </div>
          <div class="stat-card-icon stat-card-icon--blue">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="m21 15-5-5L5 21"/></svg>
          </div>
        </div>
        <div class="stat-card stat-card--green">
          <div class="stat-card-body">
            <span class="stat-card-label">Contributors</span>
            <span class="stat-card-value">{{ formatNum(countryData.total_uploaders) }}</span>
          </div>
          <div class="stat-card-icon stat-card-icon--green">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
          </div>
        </div>
        <div class="stat-card stat-card--purple">
          <div class="stat-card-body">
            <span class="stat-card-label">Active Days</span>
            <span class="stat-card-value">{{ formatNum(activeDays) }}</span>
          </div>
          <div class="stat-card-icon stat-card-icon--purple">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
          </div>
        </div>
        <div class="stat-card stat-card--orange">
          <div class="stat-card-body">
            <span class="stat-card-label">Images Used</span>
            <span class="stat-card-value">{{ formatNum(countryData.total_images_used) }}</span>
          </div>
          <div class="stat-card-icon stat-card-icon--orange">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
          </div>
        </div>
        <div class="stat-card stat-card--teal">
          <div class="stat-card-body">
            <span class="stat-card-label">New Uploaders</span>
            <span class="stat-card-value">
              {{ formatNum(countryData.total_new_uploaders) }}
              <span class="stat-pct">({{ Math.round((countryData.total_new_uploaders / countryData.total_uploaders * 100) || 0) }}%)</span>
            </span>
          </div>
          <div class="stat-card-icon stat-card-icon--teal">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg>
          </div>
        </div>
        <div class="stat-card stat-card--red">
          <div class="stat-card-body">
            <span class="stat-card-label">Avg Uploads/Day</span>
            <span class="stat-card-value">{{ formatNum(avgUploadsPerDay) }}</span>
          </div>
          <div class="stat-card-icon stat-card-icon--red">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="20" x2="12" y2="10"/><line x1="18" y1="20" x2="18" y2="4"/><line x1="6" y1="20" x2="6" y2="16"/></svg>
          </div>
        </div>
      </section>

      <!-- Daily Upload Activity Chart -->
      <section v-if="dailyChartData.length" class="chart-section">
        <h2 class="section-title">Daily Upload Activity</h2>
        <div class="chart-wrapper">
          <DailyUploadsChart :daily-data="dailyChartData" :height="300" :width="1000" />
        </div>
      </section>

      <!-- Contribution Distribution -->
      <section v-if="pieSegments.length && !uploadersLoading" class="charts-row">
        <div class="pie-section">
          <h2 class="section-title">Contribution Distribution</h2>
          <PieChart :segments="pieSegments" :size="320" />
        </div>
      </section>

      <!-- Detailed User Contributions -->
      <section class="uploaders-section">
        <div class="uploaders-header">
          <h2 class="section-title">Detailed User Contributions</h2>
          <div class="uploaders-controls">
            <input
              v-model="searchQuery"
              type="text"
              placeholder="Search user..."
              class="search-input"
            />
            <button class="ctrl-btn" @click="exportCSV">Export CSV</button>
            <button class="ctrl-btn" @click="copyWikitable">
              {{ copiedWiki ? 'Copied!' : 'Copy Wikitable' }}
            </button>
          </div>
        </div>

        <div v-if="uploadersLoading" class="uploaders-loading">
          <SkeletonLoader type="table" :lines="8" />
        </div>
        <div v-else-if="filteredUploaders.length" class="table-wrapper">
          <table class="uploaders-table">
            <thead>
              <tr>
                <th class="th-rank">Rank</th>
                <th>Username</th>
                <th class="th-num sortable" @click="toggleSort('uploads')">
                  Files Uploaded <span class="sort-icon">{{ sortIcon('uploads') }}</span>
                </th>
                <th class="th-num sortable" @click="toggleSort('percentage')">
                  Percentage <span class="sort-icon">{{ sortIcon('percentage') }}</span>
                </th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="(u, i) in filteredUploaders" :key="u.username">
                <td class="td-rank">{{ i + 1 }}</td>
                <td class="td-user">
                  <a :href="getUserUrl(u.username)" target="_blank" rel="noopener" class="user-link">
                    {{ u.username }}
                  </a>
                </td>
                <td class="td-num">{{ formatNum(u.uploads) }}</td>
                <td class="td-num">{{ u.percentage }}%</td>
              </tr>
            </tbody>
          </table>
        </div>
        <p v-else class="no-uploaders">No uploader data available yet.</p>
      </section>

      <!-- Daily Statistics Table -->
      <section v-if="countryData.daily_stats?.length" class="table-section">
        <h2 class="section-title">Daily Statistics</h2>
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
                  <a :href="getDailyUploadUrl(day.date, countryData.category_name)" class="date-link">{{ day.date }}</a>
                </td>
                <td class="num-col">{{ formatNum(day.uploads) }}</td>
                <td class="num-col">{{ formatNum(day.uploaders) }}</td>
                <td class="num-col">{{ formatNum(day.new_uploaders) }} <span class="percentage">({{ day.new_uploaders_pct }})</span></td>
              </tr>
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

/* Header */
.page-header { margin-bottom: 2rem; text-align: center; }
.page-header h1 { font-size: 2rem; font-weight: 700; margin-bottom: 0.5rem; }
.subtitle { color: var(--text-secondary, #6b7280); font-size: 0.95rem; margin: 0.5rem 0; }
.commons-link { margin: 0.75rem 0; }
.commons-link a { color: #2563eb; text-decoration: none; font-weight: 500; }
.commons-link a:hover { text-decoration: underline; }
.note { color: var(--text-secondary, #6b7280); font-size: 0.875rem; font-style: italic; margin-top: 0.5rem; }

/* Stat Cards */
.stat-cards {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
  gap: 1rem;
  margin-bottom: 2.5rem;
}

.stat-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.25rem 1.5rem;
  border-radius: 12px;
  background: var(--bg-card, #ffffff);
  border: 1px solid var(--border-color, #e5e7eb);
  border-left: 4px solid transparent;
  transition: transform 0.2s, box-shadow 0.2s;
}

.stat-card:hover {
  transform: translateY(-3px);
  box-shadow: 0 8px 24px rgba(0,0,0,0.08);
}

.stat-card--blue  { border-left-color: #3b82f6; }
.stat-card--green { border-left-color: #10b981; }
.stat-card--purple { border-left-color: #8b5cf6; }
.stat-card--orange { border-left-color: #f59e0b; }
.stat-card--teal  { border-left-color: #14b8a6; }
.stat-card--red   { border-left-color: #ef4444; }

.stat-card-body { display: flex; flex-direction: column; gap: 0.25rem; }
.stat-card-label { font-size: 0.8rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-secondary, #6b7280); }
.stat-card-value { font-size: 1.75rem; font-weight: 800; color: var(--text-primary, #111827); line-height: 1.1; }
.stat-pct { font-size: 0.875rem; font-weight: 500; color: var(--text-secondary, #6b7280); }

.stat-card-icon {
  width: 44px; height: 44px; border-radius: 10px; display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.stat-card-icon svg { width: 24px; height: 24px; }
.stat-card-icon--blue   { background: #eff6ff; color: #3b82f6; }
.stat-card-icon--green  { background: #ecfdf5; color: #10b981; }
.stat-card-icon--purple { background: #f5f3ff; color: #8b5cf6; }
.stat-card-icon--orange { background: #fffbeb; color: #f59e0b; }
.stat-card-icon--teal   { background: #f0fdfa; color: #14b8a6; }
.stat-card-icon--red    { background: #fef2f2; color: #ef4444; }

/* Section titles */
.section-title {
  font-size: 1.25rem;
  font-weight: 700;
  margin-bottom: 1rem;
  color: var(--text-primary, #111827);
}

/* Chart sections */
.chart-section {
  background: var(--bg-card, #ffffff);
  padding: 1.5rem;
  border-radius: 12px;
  border: 1px solid var(--border-color, #e5e7eb);
  margin-bottom: 2rem;
  box-shadow: 0 1px 3px rgba(0,0,0,0.06);
}

.chart-wrapper { overflow-x: auto; }

.charts-row {
  margin-bottom: 2rem;
}

.pie-section {
  background: var(--bg-card, #ffffff);
  padding: 1.5rem;
  border-radius: 12px;
  border: 1px solid var(--border-color, #e5e7eb);
  box-shadow: 0 1px 3px rgba(0,0,0,0.06);
}

/* Uploaders section */
.uploaders-section {
  background: var(--bg-card, #ffffff);
  padding: 1.5rem 2rem;
  border-radius: 12px;
  border: 1px solid var(--border-color, #e5e7eb);
  margin-bottom: 2rem;
  box-shadow: 0 1px 3px rgba(0,0,0,0.06);
}

.uploaders-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 1rem;
}

.uploaders-controls {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  flex-wrap: wrap;
}

.search-input {
  padding: 0.5rem 0.75rem;
  border: 1px solid var(--border-color, #d1d5db);
  border-radius: 8px;
  font-size: 0.875rem;
  width: 180px;
  background: var(--bg-card, #fff);
  color: var(--text-primary, #111827);
}
.search-input:focus { outline: none; border-color: #3b82f6; box-shadow: 0 0 0 3px rgba(59,130,246,0.15); }

.ctrl-btn {
  padding: 0.5rem 1rem;
  border: 1px solid var(--border-color, #d1d5db);
  border-radius: 8px;
  background: var(--bg-card, #fff);
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--text-primary, #374151);
  cursor: pointer;
  transition: all 0.15s;
}
.ctrl-btn:hover { background: var(--bg-secondary, #f3f4f6); border-color: #9ca3af; }

.uploaders-table { width: 100%; border-collapse: separate; border-spacing: 0; font-size: 0.9375rem; }
.uploaders-table thead th {
  text-align: left; padding: 0.875rem 1rem; background: var(--bg-secondary, #f9fafb);
  color: var(--text-secondary, #374151); font-weight: 700; font-size: 0.8125rem;
  text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid var(--border-color, #e5e7eb);
}
.sortable { cursor: pointer; user-select: none; }
.sortable:hover { color: #2563eb; }
.sort-icon { font-size: 0.75rem; opacity: 0.6; }
.th-rank { width: 60px; }
.th-num { text-align: right; }

.uploaders-table tbody td { padding: 0.75rem 1rem; border-bottom: 1px solid var(--border-color, #f3f4f6); }
.uploaders-table tbody tr { transition: background 0.15s; }
.uploaders-table tbody tr:nth-child(even) { background: var(--bg-secondary, #f9fafb); }
.uploaders-table tbody tr:hover { background: var(--bg-hover, #f0f4ff); }

.td-rank { font-weight: 600; color: var(--text-secondary, #6b7280); width: 60px; }
.td-user { font-weight: 500; }
.td-num { text-align: right; font-variant-numeric: tabular-nums; font-weight: 600; }

.user-link { color: #2563eb; text-decoration: none; font-weight: 600; }
.user-link:hover { text-decoration: underline; }

.uploaders-loading, .no-uploaders {
  text-align: center; padding: 2rem; color: var(--text-secondary, #6b7280);
}

/* Daily Stats Table */
.table-section {
  background: var(--bg-card, #ffffff);
  padding: 1.5rem 2rem;
  border-radius: 12px;
  box-shadow: 0 1px 3px rgba(0,0,0,0.06);
  border: 1px solid var(--border-color, #e5e7eb);
  margin-bottom: 2rem;
}

.table-wrapper { overflow-x: auto; border-radius: 8px; border: 1px solid var(--border-color, #e5e7eb); }

table { width: 100%; border-collapse: separate; border-spacing: 0; font-size: 0.9375rem; }
thead th {
  text-align: left; padding: 1rem; background: var(--bg-secondary, #f9fafb);
  color: var(--text-secondary, #374151); font-weight: 700; font-size: 0.8125rem;
  text-transform: uppercase; letter-spacing: 0.5px; border-bottom: 2px solid var(--border-color, #e5e7eb); white-space: nowrap;
}
td { padding: 0.875rem 1rem; border-bottom: 1px solid var(--border-color, #f3f4f6); }
tbody tr { transition: background 0.15s; }
tbody tr:nth-child(even) { background: var(--bg-secondary, #f9fafb); }
tbody tr:hover:not(.total-row) { background: var(--bg-hover, #f3f4f6); }

.total-row { background: linear-gradient(135deg, #eff6ff 0%, #dbeafe 100%) !important; border-top: 2px solid #2563eb; }
.total-row td { padding: 1rem; color: #1e40af; }

.date-col { font-weight: 500; min-width: 120px; }
.date-link { color: #2563eb; text-decoration: none; font-weight: 600; }
.date-link:hover { text-decoration: underline; }
.num-col { text-align: right; font-variant-numeric: tabular-nums; font-weight: 600; }
.percentage { color: var(--text-secondary, #6b7280); font-weight: 400; font-size: 0.875rem; }

/* Footer */
.page-footer { text-align: center; padding: 2rem 0; color: var(--text-secondary, #6b7280); font-size: 0.875rem; border-top: 1px solid var(--border-color, #e5e7eb); }
.page-footer a { color: #2563eb; text-decoration: none; }
.page-footer a:hover { text-decoration: underline; }

/* States */
.loading-state { text-align: center; padding: 4rem 2rem; }
.error-state { text-align: center; padding: 4rem 2rem; background: linear-gradient(135deg, #fef2f2 0%, #fee2e2 100%); border-radius: 12px; border: 1px solid #fecaca; color: #991b1b; }
.error-state h2 { color: #dc2626; margin-bottom: 1rem; }
.back-btn { margin-top: 1.5rem; padding: 0.75rem 1.5rem; background: #dc2626; color: white; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; }
.back-btn:hover { background: #b91c1c; }

@media (max-width: 768px) {
  .campaign-country-view { padding: 1rem; }
  .page-header h1 { font-size: 1.5rem; }
  .stat-cards { grid-template-columns: 1fr 1fr; gap: 0.75rem; }
  .stat-card { padding: 1rem; }
  .stat-card-value { font-size: 1.35rem; }
  .uploaders-header { flex-direction: column; align-items: stretch; }
  .uploaders-controls { justify-content: stretch; }
  .search-input { width: 100%; }
}
</style>
