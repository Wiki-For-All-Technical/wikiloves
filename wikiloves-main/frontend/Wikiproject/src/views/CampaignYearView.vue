<script setup>
import { computed } from 'vue'
import { getCampaignData } from '@/data/campaigns'
import scienceData from '@/data/wiki-science-competition.json'
import CountryCumulativeChart from '@/components/CountryCumulativeChart.vue'

const props = defineProps({
  slug: { type: String, required: true },
  year: { type: [Number, String], required: true },
})

const yearNum = computed(() => parseInt(props.year, 10))

const campaignData = computed(() => {
  if (props.slug === 'science') return scienceData
  return getCampaignData(props.slug)
})

const yearData = computed(() => {
  const data = campaignData.value
  if (!data?.years) return null
  return data.years.find((y) => y.year === yearNum.value) ?? null
})

const campaignName = computed(() => campaignData.value?.campaign_name ?? 'Wiki Loves')
const campaignPath = computed(() => (props.slug === 'science' ? '/science' : `/${props.slug}`))

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

const graphMax = computed(() => {
  const y = yearData.value
  if (!y) return 10000
  return Math.max(y.uploads ?? 0, 1000)
})

const formatNumber = (v) => (v != null ? v.toLocaleString() : '—')
const formatPercent = (v) => (v != null ? `${v}%` : '—')

const barColors = [
  '#16a34a', '#2563eb', '#9333ea', '#ca8a04', '#dc2626', '#0891b2', '#c026d3',
  '#65a30d', '#4f46e5', '#ea580c', '#0d9488', '#be185d', '#84cc16', '#7c3aed',
]
const barColor = (index) => barColors[index % barColors.length]
</script>

<template>
  <div class="year-page">
    <header class="year-header">
      <div class="year-header-inner">
        <router-link :to="campaignPath" class="year-back">
          <span class="year-back-icon" aria-hidden="true">←</span>
          <span>{{ campaignName }}</span>
        </router-link>
      </div>
    </header>

    <template v-if="yearData">
      <main class="year-main">
        <section class="year-hero">
          <h1 class="year-title">{{ campaignName }} {{ yearNum }}</h1>
          <p class="year-subtitle">Tool Labs – Tools for Wiki Loves Photo Competitions</p>
        </section>

        <section class="year-stats-section" aria-label="Competition statistics">
          <h2 class="year-stats-heading">Statistics</h2>
          <div class="year-stats-grid">
            <div class="year-stat-card">
              <span class="year-stat-value">{{ formatNumber(yearData.uploads) }}</span>
              <span class="year-stat-label">Total images</span>
            </div>
            <div class="year-stat-card">
              <span class="year-stat-value">{{ formatNumber(yearData.images_used) }}</span>
              <span class="year-stat-label">Images used in wikis</span>
              <span v-if="yearData.images_used_pct != null" class="year-stat-meta">({{ yearData.images_used_pct }}%)</span>
            </div>
            <div class="year-stat-card">
              <span class="year-stat-value">{{ formatNumber(yearData.countries) }}</span>
              <span class="year-stat-label">Countries</span>
            </div>
            <div class="year-stat-card">
              <span class="year-stat-value">{{ formatNumber(yearData.uploaders) }}</span>
              <span class="year-stat-label">Uploaders</span>
            </div>
            <div class="year-stat-card">
              <span class="year-stat-value">{{ formatNumber(yearData.new_uploaders) }}</span>
              <span class="year-stat-label">New uploaders (after start)</span>
              <span v-if="yearData.new_uploaders_pct != null" class="year-stat-meta">({{ yearData.new_uploaders_pct }}%)</span>
            </div>
          </div>
        </section>

        <section class="year-graph-section">
          <div class="year-graph-wrap" :class="{ 'year-graph-wrap--country': countryRows?.length }">
            <CountryCumulativeChart
              v-if="countryRows?.length"
              :country-rows="countryRows"
              :colors="barColors"
              :height="280"
            />
            <svg
              v-else
              class="year-graph"
              viewBox="0 0 400 180"
              preserveAspectRatio="none"
              aria-hidden="true"
            >
              <defs>
                <linearGradient id="yearGraphGrad" x1="0%" y1="0%" x2="0%" y2="100%">
                  <stop offset="0%" stop-color="#16a34a" stop-opacity="0.3" />
                  <stop offset="100%" stop-color="#16a34a" stop-opacity="0" />
                </linearGradient>
              </defs>
              <line x1="40" y1="160" x2="380" y2="160" stroke="#e5e7eb" stroke-width="1" />
              <line x1="40" y1="120" x2="380" y2="120" stroke="#e5e7eb" stroke-width="1" />
              <line x1="40" y1="80" x2="380" y2="80" stroke="#e5e7eb" stroke-width="1" />
              <line x1="40" y1="40" x2="380" y2="40" stroke="#e5e7eb" stroke-width="1" />
              <polyline
                class="year-graph-line"
                :points="`40,160 80,${160 - (120 * (yearData.uploads || 0) / graphMax)} 160,${160 - (100 * (yearData.uploads || 0) / graphMax)} 240,${160 - (60 * (yearData.uploads || 0) / graphMax)} 320,${160 - (25 * (yearData.uploads || 0) / graphMax)} 380,20`"
                fill="none"
                stroke="#16a34a"
                stroke-width="2.5"
                stroke-linecap="round"
                stroke-linejoin="round"
              />
              <polygon
                class="year-graph-area"
                :points="`40,160 80,${160 - (120 * (yearData.uploads || 0) / graphMax)} 160,${160 - (100 * (yearData.uploads || 0) / graphMax)} 240,${160 - (60 * (yearData.uploads || 0) / graphMax)} 320,${160 - (25 * (yearData.uploads || 0) / graphMax)} 380,20 380,160 40,160`"
                fill="url(#yearGraphGrad)"
              />
            </svg>
          </div>
          <p class="year-graph-caption">Cumulative uploads over competition period</p>
        </section>

        <section class="year-table-section">
          <div class="year-table-wrap">
            <table class="year-table">
              <thead>
                <tr>
                  <th class="year-th-bar" aria-label="Rank" />
                  <th class="year-th-rank">#</th>
                  <th>Country</th>
                  <th>Images*</th>
                  <th>Images used in the wikis</th>
                  <th>Uploaders</th>
                  <th>Uploaders registered after competition start</th>
                </tr>
              </thead>
              <tbody>
                <tr v-for="(row, i) in tableRows" :key="row.country" class="year-row">
                  <td class="year-td-bar">
                    <span class="year-bar" :style="{ backgroundColor: barColor(i) }" />
                  </td>
                  <td class="year-td-rank">{{ i + 1 }}</td>
                  <td class="year-td-country">
                    <router-link
                      :to="`/${slug}/${yearNum}/${row.country}`"
                      class="year-country-link"
                    >
                      {{ row.country }}
                    </router-link>
                  </td>
                  <td class="year-td-num">{{ formatNumber(row.images) }}</td>
                  <td class="year-td-num">
                    {{ formatNumber(row.images_used) }}
                    <span v-if="row.images_used_pct != null" class="year-pct">({{ row.images_used_pct }}%)</span>
                  </td>
                  <td class="year-td-num">{{ formatNumber(row.uploaders) }}</td>
                  <td class="year-td-num">
                    {{ formatNumber(row.new_uploaders) }}
                    <span v-if="row.new_uploaders_pct != null" class="year-pct">({{ row.new_uploaders_pct }}%)</span>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        </section>
      </main>
    </template>

    <div v-else class="year-not-found">
      <p>No data for this year.</p>
      <router-link :to="campaignPath" class="year-back-link">Back to {{ campaignName }}</router-link>
    </div>
  </div>
</template>

<style scoped>
.year-page {
  min-height: 100vh;
  background: #fff;
  color: #1a1a1a;
}

.year-header {
  border-bottom: 1px solid #e5e7eb;
  background: #fff;
}

.year-header-inner {
  max-width: 1000px;
  margin: 0 auto;
  padding: 1rem 1.5rem;
}

.year-back {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  color: #0366d6;
  font-size: 0.9375rem;
  font-weight: 500;
  text-decoration: none;
}

.year-back:hover {
  text-decoration: underline;
}

.year-back-icon {
  font-size: 1.1rem;
}

.year-main {
  max-width: 1000px;
  margin: 0 auto;
  padding: 2rem 1.5rem 3rem;
}

.year-hero {
  margin-bottom: 2rem;
}

.year-title {
  margin: 0 0 0.35rem;
  font-size: clamp(1.75rem, 4vw, 2.25rem);
  font-weight: 700;
  color: #111;
  line-height: 1.2;
}

.year-subtitle {
  margin: 0;
  font-size: 0.9375rem;
  color: #6b7280;
}

.year-stats-section {
  margin-bottom: 2rem;
}

.year-stats-heading {
  margin: 0 0 1rem;
  font-size: 1.125rem;
  font-weight: 600;
  color: #374151;
}

.year-stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(160px, 1fr));
  gap: 1rem;
}

.year-stat-card {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  padding: 1rem 1.25rem;
  background: #f9fafb;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
}

.year-stat-value {
  font-size: 1.5rem;
  font-weight: 700;
  color: #111;
  font-variant-numeric: tabular-nums;
}

.year-stat-label {
  font-size: 0.8125rem;
  color: #6b7280;
  line-height: 1.3;
}

.year-stat-meta {
  font-size: 0.75rem;
  color: #9ca3af;
}

.year-graph-section {
  margin-bottom: 2rem;
}

.year-graph-wrap {
  width: 100%;
  height: 200px;
  background: #f9fafb;
  border-radius: 8px;
  border: 1px solid #e5e7eb;
  overflow: hidden;
}

.year-graph-wrap--country {
  height: auto;
  min-height: 280px;
  overflow: visible;
}

.year-graph {
  width: 100%;
  height: 100%;
  display: block;
}

.year-graph-caption {
  margin: 0.5rem 0 0;
  font-size: 0.8125rem;
  color: #6b7280;
}

.year-table-section {
  margin-top: 1.5rem;
}

.year-table-wrap {
  overflow-x: auto;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  background: #fff;
}

.year-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.9375rem;
}

.year-table thead tr {
  background: #f3f4f6;
  border-bottom: 2px solid #e5e7eb;
}

.year-table th {
  padding: 0.75rem 1rem;
  text-align: left;
  font-weight: 600;
  color: #374151;
  font-size: 0.8125rem;
  text-transform: uppercase;
  letter-spacing: 0.03em;
}

.year-th-bar {
  width: 12px;
  padding: 0.5rem 0.25rem !important;
  border-right: 1px solid #e5e7eb;
}

.year-th-rank {
  width: 36px;
  text-align: center;
}

.year-table td {
  padding: 0.75rem 1rem;
  border-bottom: 1px solid #f3f4f6;
  color: #374151;
}

.year-table tbody tr:last-child td {
  border-bottom: none;
}

.year-table tbody tr:hover {
  background: #f9fafb;
}

.year-td-bar {
  width: 12px;
  padding: 0.5rem 0.25rem !important;
  vertical-align: middle;
  border-right: 1px solid #e5e7eb;
}

.year-td-rank {
  text-align: center;
  font-weight: 600;
  color: #6b7280;
}

.year-td-country {
  font-weight: 500;
}

.year-country-link {
  color: #0366d6;
  cursor: pointer;
}

.year-country-link:hover {
  text-decoration: underline;
}

.year-td-num {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

.year-pct {
  margin-left: 0.25rem;
  color: #6b7280;
  font-weight: 400;
}

.year-not-found {
  max-width: 1000px;
  margin: 0 auto;
  padding: 3rem 1.5rem;
  text-align: center;
}

.year-not-found p {
  margin: 0 0 1rem;
  color: #6b7280;
}

.year-back-link {
  color: #0366d6;
  font-size: 0.9375rem;
  text-decoration: underline;
}

.year-back-link:hover {
  color: #0550a0;
}

@media (max-width: 768px) {
  .year-main {
    padding: 1.5rem 1rem 2rem;
  }

  .year-table th,
  .year-table td {
    padding: 0.5rem 0.75rem;
    font-size: 0.875rem;
  }
}
</style>
