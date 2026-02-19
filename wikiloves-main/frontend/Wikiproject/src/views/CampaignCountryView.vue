<script setup>
import { computed, onMounted, watch, ref } from 'vue'
import { useRoute } from 'vue-router'
import { useCatalogStore } from '@/stores/catalog'
import { fetchToolforgeCountryUploaders } from '@/services/api'
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
  '#2563eb', '#10b981', '#f59e0b', '#ef4444', '#8b5cf6',
  '#06b6d4', '#ec4899', '#f97316', '#6366f1', '#14b8a6',
]

async function loadData() {
  loading.value = true
  error.value = null
  try {
    if (!catalog.navigation.length) await catalog.loadNavigation()
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

const activeDays = computed(() => countryData.value?.daily_stats?.length || 0)
const avgUploadsPerDay = computed(() => {
  const days = activeDays.value
  if (!days) return 0
  return Math.round((countryData.value?.total_uploads || 0) / days)
})

const dailyChartData = computed(() =>
  (countryData.value?.daily_stats || []).map(d => ({ date: d.date, count: d.uploads }))
)

const pieSegments = computed(() => {
  const top = uploaders.value.slice(0, 8)
  const topTotal = top.reduce((s, u) => s + u.uploads, 0)
  const rest = (uploadersTotal.value || countryData.value?.total_uploads || 0) - topTotal
  const segs = top.map((u, i) => ({ label: u.username, value: u.uploads, color: PIE_COLORS[i % PIE_COLORS.length] }))
  if (rest > 0) segs.push({ label: 'Others', value: rest, color: '#cbd5e1' })
  return segs
})

const filteredUploaders = computed(() => {
  let list = [...uploaders.value]
  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase()
    list = list.filter(u => u.username.toLowerCase().includes(q))
  }
  list.sort((a, b) => {
    const va = a[sortField.value] || 0, vb = b[sortField.value] || 0
    return sortDir.value === 'desc' ? vb - va : va - vb
  })
  return list
})

function toggleSort(field) {
  if (sortField.value === field) sortDir.value = sortDir.value === 'desc' ? 'asc' : 'desc'
  else { sortField.value = field; sortDir.value = 'desc' }
}

function sortIcon(field) {
  if (sortField.value !== field) return '↕'
  return sortDir.value === 'desc' ? '↓' : '↑'
}

function exportCSV() {
  const header = 'Rank,Username,Files Uploaded,Percentage\n'
  const rows = filteredUploaders.value.map((u, i) => `${i + 1},"${u.username}",${u.uploads},${u.percentage}%`).join('\n')
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
  const rows = filteredUploaders.value.map((u, i) => `|-\n| ${i + 1} || [[User:${u.username}|${u.username}]] || ${u.uploads} || ${u.percentage}%`).join('\n')
  navigator.clipboard.writeText(header + rows + '\n|}')
  copiedWiki.value = true
  setTimeout(() => { copiedWiki.value = false }, 2000)
}

function formatNum(num) { return new Intl.NumberFormat('en-US').format(num) }

function getDailyUploadUrl(date, cat) {
  return `https://heritage.toolforge.org/tools/daily-uploads/daily-uploads.html?date=${date}&category=${encodeURIComponent(cat)}&load=true`
}

function getCommonsUrl(cat) { return `https://commons.wikimedia.org/wiki/Category:${cat}` }
function getUserUrl(u) { return `https://commons.wikimedia.org/wiki/User:${encodeURIComponent(u)}` }
</script>

<template>
  <div class="page">
    <div class="page-inner">
      <div v-if="loading" class="loading-state">
        <SkeletonLoader type="card" height="200px" />
        <SkeletonLoader type="table" :lines="10" />
      </div>

      <div v-else-if="error" class="error-state">
        <h2>Error loading data</h2>
        <p>{{ error }}</p>
        <button @click="$router.back()" class="back-btn">&larr; Go Back</button>
      </div>

      <template v-else-if="countryData">
        <!-- Breadcrumb -->
        <nav class="breadcrumb" aria-label="Breadcrumb">
          <router-link to="/">Home</router-link>
          <span class="sep">/</span>
          <router-link :to="`/${segment}`">{{ countryData.campaign }}</router-link>
          <span class="sep">/</span>
          <router-link :to="`/${segment}/${year}`">{{ year }}</router-link>
          <span class="sep">/</span>
          <span class="current">{{ countryData.country }}</span>
        </nav>

        <!-- Hero -->
        <header class="page-hero">
          <h1 class="page-title">{{ countryData.campaign }} {{ countryData.year }} &ndash; {{ countryData.country }}</h1>
          <p class="page-subtitle">
            <a :href="getCommonsUrl(countryData.category_name)">View category on Wikimedia Commons</a>
            &middot; All times are UTC
          </p>
        </header>

        <!-- Stat Cards -->
        <section class="stats-row">
          <div class="stat-card stat-card--accent">
            <div class="stat-card-body">
              <span class="stat-label">Total Images</span>
              <span class="stat-value">{{ formatNum(countryData.total_uploads) }}</span>
            </div>
            <div class="stat-icon stat-icon--accent">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="3" width="18" height="18" rx="2"/><circle cx="8.5" cy="8.5" r="1.5"/><path d="m21 15-5-5L5 21"/></svg>
            </div>
          </div>
          <div class="stat-card stat-card--green">
            <div class="stat-card-body">
              <span class="stat-label">Contributors</span>
              <span class="stat-value">{{ formatNum(countryData.total_uploaders) }}</span>
            </div>
            <div class="stat-icon stat-icon--green">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><path d="M22 21v-2a4 4 0 0 0-3-3.87"/><path d="M16 3.13a4 4 0 0 1 0 7.75"/></svg>
            </div>
          </div>
          <div class="stat-card stat-card--purple">
            <div class="stat-card-body">
              <span class="stat-label">Active Days</span>
              <span class="stat-value">{{ formatNum(activeDays) }}</span>
            </div>
            <div class="stat-icon stat-icon--purple">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="4" width="18" height="18" rx="2"/><line x1="16" y1="2" x2="16" y2="6"/><line x1="8" y1="2" x2="8" y2="6"/><line x1="3" y1="10" x2="21" y2="10"/></svg>
            </div>
          </div>
          <div class="stat-card stat-card--orange">
            <div class="stat-card-body">
              <span class="stat-label">Images Used</span>
              <span class="stat-value">{{ formatNum(countryData.total_images_used) }}</span>
            </div>
            <div class="stat-icon stat-icon--orange">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><polyline points="22 12 18 12 15 21 9 3 6 12 2 12"/></svg>
            </div>
          </div>
          <div class="stat-card stat-card--teal">
            <div class="stat-card-body">
              <span class="stat-label">New Uploaders</span>
              <span class="stat-value">{{ formatNum(countryData.total_new_uploaders) }} <span class="stat-pct">({{ Math.round((countryData.total_new_uploaders / countryData.total_uploaders * 100) || 0) }}%)</span></span>
            </div>
            <div class="stat-icon stat-icon--teal">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2"/><circle cx="9" cy="7" r="4"/><line x1="19" y1="8" x2="19" y2="14"/><line x1="22" y1="11" x2="16" y2="11"/></svg>
            </div>
          </div>
          <div class="stat-card stat-card--red">
            <div class="stat-card-body">
              <span class="stat-label">Avg Uploads/Day</span>
              <span class="stat-value">{{ formatNum(avgUploadsPerDay) }}</span>
            </div>
            <div class="stat-icon stat-icon--red">
              <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><line x1="12" y1="20" x2="12" y2="10"/><line x1="18" y1="20" x2="18" y2="4"/><line x1="6" y1="20" x2="6" y2="16"/></svg>
            </div>
          </div>
        </section>

        <!-- Daily Upload Chart -->
        <section v-if="dailyChartData.length" class="card-section">
          <h2 class="section-heading">Daily Upload Activity</h2>
          <div class="chart-wrap"><DailyUploadsChart :daily-data="dailyChartData" :height="300" :width="1000" /></div>
        </section>

        <!-- Pie Chart -->
        <section v-if="pieSegments.length && !uploadersLoading" class="card-section">
          <h2 class="section-heading">Contribution Distribution</h2>
          <PieChart :segments="pieSegments" :size="320" />
        </section>

        <!-- Uploaders Table -->
        <section class="card-section">
          <div class="section-header">
            <h2 class="section-heading">User Contributions</h2>
            <div class="controls">
              <input v-model="searchQuery" type="text" placeholder="Search user..." class="search-input" />
              <button class="ctrl-btn" @click="exportCSV">Export CSV</button>
              <button class="ctrl-btn" @click="copyWikitable">{{ copiedWiki ? 'Copied!' : 'Copy Wikitable' }}</button>
            </div>
          </div>
          <div v-if="uploadersLoading" class="loading-msg"><SkeletonLoader type="table" :lines="8" /></div>
          <div v-else-if="filteredUploaders.length" class="table-wrap">
            <table class="data-table">
              <thead>
                <tr>
                  <th class="th-rank">Rank</th>
                  <th>Username</th>
                  <th class="th-num sortable" @click="toggleSort('uploads')">Files <span class="sort-icon">{{ sortIcon('uploads') }}</span></th>
                  <th class="th-num sortable" @click="toggleSort('percentage')">% <span class="sort-icon">{{ sortIcon('percentage') }}</span></th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(u, i) in filteredUploaders" :key="u.username">
                  <td class="td-rank">{{ i + 1 }}</td>
                  <td><a :href="getUserUrl(u.username)" target="_blank" rel="noopener" class="user-link">{{ u.username }}</a></td>
                  <td class="td-num">{{ formatNum(u.uploads) }}</td>
                  <td class="td-num">{{ u.percentage }}%</td>
                </tr>
              </tbody>
            </table>
          </div>
          <p v-else class="empty-msg">No uploader data available yet.</p>
        </section>

        <!-- Daily Stats Table -->
        <section v-if="countryData.daily_stats?.length" class="card-section">
          <h2 class="section-heading">Daily Statistics</h2>
          <div class="table-wrap">
            <table class="data-table">
              <thead>
                <tr>
                  <th>Date</th>
                  <th class="th-num">Images</th>
                  <th class="th-num">Joiners</th>
                  <th class="th-num">New Uploaders</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="day in countryData.daily_stats" :key="day.date">
                  <td><a :href="getDailyUploadUrl(day.date, countryData.category_name)" class="date-link">{{ day.date }}</a></td>
                  <td class="td-num">{{ formatNum(day.uploads) }}</td>
                  <td class="td-num">{{ formatNum(day.uploaders) }}</td>
                  <td class="td-num">{{ formatNum(day.new_uploaders) }} <span class="pct">({{ day.new_uploaders_pct }})</span></td>
                </tr>
                <tr class="total-row">
                  <td><strong>Total</strong></td>
                  <td class="td-num"><strong>{{ formatNum(countryData.total_uploads) }}</strong></td>
                  <td class="td-num"><strong>{{ formatNum(countryData.total_uploaders) }}</strong></td>
                  <td class="td-num"><strong>{{ formatNum(countryData.total_new_uploaders) }}</strong> <span class="pct">({{ Math.round((countryData.total_new_uploaders / countryData.total_uploaders * 100) || 0) }}%)</span></td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>

        <footer class="page-footer">
          <p>Source available under <a href="https://www.gnu.org/licenses/gpl-3.0.html" target="_blank">GPL v3</a></p>
        </footer>
      </template>
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
.breadcrumb { font-size: 0.875rem; margin-bottom: 2rem; color: var(--text-muted); }
.breadcrumb a { color: var(--color-accent); text-decoration: none; font-weight: 500; }
.breadcrumb a:hover { text-decoration: underline; }
.sep { margin: 0 0.5rem; }
.current { color: var(--text-primary); font-weight: 600; }

/* Hero */
.page-hero { margin-bottom: 2rem; }
.page-title {
  margin: 0 0 0.5rem;
  font-size: clamp(1.5rem, 3.5vw, 2.25rem);
  font-weight: 800;
  letter-spacing: -0.03em;
  color: var(--text-primary);
}
.page-subtitle { margin: 0; font-size: 0.9375rem; color: var(--text-secondary); }
.page-subtitle a { color: var(--color-accent); }

/* Stats */
.stats-row {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 1rem;
  margin-bottom: 2.5rem;
}

.stat-card {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 1.25rem 1.5rem;
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-left: 4px solid var(--color-accent);
  border-radius: var(--radius-md);
  box-shadow: var(--shadow-sm);
  transition: transform 0.15s, box-shadow 0.15s;
}
.stat-card:hover { transform: translateY(-2px); box-shadow: var(--shadow-md); }

.stat-card--accent { border-left-color: #2563eb; }
.stat-card--green  { border-left-color: #10b981; }
.stat-card--purple { border-left-color: #8b5cf6; }
.stat-card--orange { border-left-color: #f59e0b; }
.stat-card--teal   { border-left-color: #14b8a6; }
.stat-card--red    { border-left-color: #ef4444; }

.stat-card-body { display: flex; flex-direction: column; gap: 0.25rem; }
.stat-label { font-size: 0.75rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.06em; color: var(--text-secondary); }
.stat-value { font-size: 1.75rem; font-weight: 800; color: var(--text-primary); font-variant-numeric: tabular-nums; line-height: 1.1; letter-spacing: -0.03em; }
.stat-pct { font-size: 0.8125rem; font-weight: 500; color: var(--text-muted); }

.stat-icon {
  width: 42px; height: 42px; border-radius: var(--radius-sm);
  display: flex; align-items: center; justify-content: center; flex-shrink: 0;
}
.stat-icon svg { width: 22px; height: 22px; }
.stat-icon--accent { background: #eff6ff; color: #2563eb; }
.stat-icon--green  { background: #ecfdf5; color: #10b981; }
.stat-icon--purple { background: #f5f3ff; color: #8b5cf6; }
.stat-icon--orange { background: #fffbeb; color: #f59e0b; }
.stat-icon--teal   { background: #f0fdfa; color: #14b8a6; }
.stat-icon--red    { background: #fef2f2; color: #ef4444; }

/* Card sections */
.card-section {
  background: var(--bg-card);
  padding: 1.5rem 2rem;
  border-radius: var(--radius-md);
  border: 1px solid var(--border-color);
  margin-bottom: 1.5rem;
  box-shadow: var(--shadow-sm);
}

.section-heading {
  margin: 0 0 1rem;
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--text-primary);
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 1rem;
  margin-bottom: 1rem;
}

.chart-wrap { overflow-x: auto; }

/* Controls */
.controls { display: flex; align-items: center; gap: 0.5rem; flex-wrap: wrap; }

.search-input {
  padding: 0.5rem 0.75rem;
  border: 1px solid var(--border-color);
  border-radius: var(--radius-sm);
  font-size: 0.875rem;
  width: 180px;
  background: var(--bg-card);
  color: var(--text-primary);
}
.search-input:focus { outline: none; border-color: var(--color-accent); box-shadow: 0 0 0 3px rgba(37,99,235,0.12); }

.ctrl-btn {
  padding: 0.5rem 1rem;
  border: 1px solid var(--border-color);
  border-radius: var(--radius-sm);
  background: var(--bg-card);
  font-size: 0.8125rem;
  font-weight: 600;
  color: var(--text-primary);
  cursor: pointer;
  transition: all 0.15s;
}
.ctrl-btn:hover { border-color: var(--color-accent); color: var(--color-accent); }

/* Tables */
.table-wrap {
  overflow-x: auto;
  border-radius: var(--radius-sm);
  border: 1px solid var(--border-color);
}

.data-table { width: 100%; border-collapse: collapse; font-size: 0.9375rem; }
.data-table thead tr { background: var(--bg-secondary); border-bottom: 2px solid var(--border-color); }
.data-table th {
  padding: 0.875rem 1rem; text-align: left; font-weight: 700;
  color: var(--text-secondary); font-size: 0.75rem; text-transform: uppercase;
  letter-spacing: 0.05em;
}
.data-table td { padding: 0.75rem 1rem; border-bottom: 1px solid var(--border-color); color: var(--text-primary); }
.data-table tbody tr:last-child td { border-bottom: none; }
.data-table tbody tr:hover:not(.total-row) { background: var(--bg-hover); }

.th-rank { width: 60px; }
.th-num { text-align: right; }
.td-rank { font-weight: 600; color: var(--text-muted); width: 60px; }
.td-num { text-align: right; font-variant-numeric: tabular-nums; font-weight: 600; }

.sortable { cursor: pointer; user-select: none; }
.sortable:hover { color: var(--color-accent); }
.sort-icon { font-size: 0.75rem; opacity: 0.5; }

.user-link { color: var(--color-accent); text-decoration: none; font-weight: 600; }
.user-link:hover { text-decoration: underline; }
.date-link { color: var(--color-accent); text-decoration: none; font-weight: 600; }
.date-link:hover { text-decoration: underline; }
.pct { color: var(--text-muted); font-weight: 400; font-size: 0.875rem; margin-left: 0.25rem; }

.total-row { background: #eff6ff !important; }
.total-row td { border-top: 2px solid var(--color-accent); color: #1e40af; }

.loading-msg, .empty-msg { text-align: center; padding: 2rem; color: var(--text-muted); }

/* Footer */
.page-footer { text-align: center; padding: 2rem 0; color: var(--text-muted); font-size: 0.8125rem; border-top: 1px solid var(--border-color); }
.page-footer a { color: var(--text-secondary); }

/* States */
.loading-state { text-align: center; padding: 4rem 2rem; }
.error-state {
  text-align: center; padding: 3rem; background: var(--bg-card); border-radius: var(--radius-md);
  border: 1px solid #fecaca; color: #991b1b;
}
.error-state h2 { color: #dc2626; margin-bottom: 1rem; }
.back-btn {
  margin-top: 1rem; padding: 0.625rem 1.5rem; background: #dc2626; color: white;
  border: none; border-radius: var(--radius-sm); font-weight: 600; cursor: pointer;
}
.back-btn:hover { background: #b91c1c; }

@media (max-width: 768px) {
  .page-inner { padding: 1.5rem; }
  .stats-row { grid-template-columns: 1fr 1fr; }
  .stat-value { font-size: 1.35rem; }
  .section-header { flex-direction: column; align-items: stretch; }
  .controls { justify-content: stretch; }
  .search-input { width: 100%; }
}
</style>
