<script setup>
import { ref, computed, watchEffect } from 'vue'
import { getCampaignData } from '@/data/campaigns'
import { fetchToolforgeCampaignData } from '@/services/api'
import CountryCumulativeChart from '@/components/CountryCumulativeChart.vue'

const props = defineProps({
  slug: { type: String, required: true },
  year: { type: [Number, String], required: true },
})

const yearNum = computed(() => parseInt(props.year, 10))

const apiData = ref(null)
const loading = ref(true)

watchEffect(async () => {
  loading.value = true
  apiData.value = null
  try {
    apiData.value = await fetchToolforgeCampaignData(props.slug)
  } catch (_) {
    // Toolforge unavailable; fall back to static JSON
  } finally {
    loading.value = false
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

const tableRows = computed(() => {
  if (countryRows.value?.length) return countryRows.value
  if (fallbackRow.value) return [fallbackRow.value]
  return []
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
            <span class="stat-value">{{ formatNumber(yearData.uploads) }}</span>
            <span class="stat-label">Total Images</span>
          </div>
          <div class="stat-card stat-card--green">
            <span class="stat-value">{{ formatNumber(yearData.images_used) }}</span>
            <span class="stat-label">Images Used</span>
            <span v-if="yearData.images_used_pct != null" class="stat-meta">({{ yearData.images_used_pct }}%)</span>
          </div>
          <div class="stat-card stat-card--purple">
            <span class="stat-value">{{ formatNumber(yearData.countries) }}</span>
            <span class="stat-label">Countries</span>
          </div>
          <div class="stat-card stat-card--orange">
            <span class="stat-value">{{ formatNumber(yearData.uploaders) }}</span>
            <span class="stat-label">Uploaders</span>
          </div>
          <div class="stat-card stat-card--teal">
            <span class="stat-value">{{ formatNumber(yearData.new_uploaders) }}</span>
            <span class="stat-label">New Uploaders</span>
            <span v-if="yearData.new_uploaders_pct != null" class="stat-meta">({{ yearData.new_uploaders_pct }}%)</span>
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
          <div class="table-wrap">
            <table class="data-table">
              <thead>
                <tr>
                  <th class="th-bar"></th>
                  <th class="th-rank">#</th>
                  <th>Country</th>
                  <th class="th-num">Images</th>
                  <th class="th-num">Images Used</th>
                  <th class="th-num">Uploaders</th>
                  <th class="th-num">New Uploaders</th>
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

@media (max-width: 768px) {
  .page-inner { padding: 1.5rem; }
  .stats-row { grid-template-columns: 1fr 1fr; }
  .stat-value { font-size: 1.35rem; }
  .data-table th, .data-table td { padding: 0.5rem 0.75rem; font-size: 0.875rem; }
}
</style>
