<script setup>
import { ref, computed } from 'vue'
import scienceData from '@/data/wiki-science-competition.json'

const sortedYears = computed(() => {
  return [...(scienceData.years || [])].sort((a, b) => b.year - a.year)
})

const selectedYear = ref(null)

const totals = computed(() => {
  const y = scienceData.years || []
  return {
    uploads: y.reduce((s, r) => s + (r.uploads || 0), 0),
    countries: Math.max(...y.map(r => r.countries || 0), 0),
    uploaders: y.reduce((s, r) => s + (r.uploaders || 0), 0),
    years: y.length,
  }
})

const displayStats = computed(() => {
  if (selectedYear.value == null) {
    return totals.value
  }
  const row = scienceData.years?.find(r => r.year === selectedYear.value)
  if (!row) return totals.value
  return {
    uploads: row.uploads ?? 0,
    countries: row.countries ?? 0,
    uploaders: row.uploaders ?? 0,
    years: 1,
  }
})

const tableRows = computed(() => {
  if (selectedYear.value == null) return sortedYears.value
  const row = sortedYears.value.find(r => r.year === selectedYear.value)
  return row ? [row] : sortedYears.value
})

const formatNumber = (value) => (value != null ? value.toLocaleString() : '—')
const formatPercent = (value) => (value != null ? `${value}%` : '—')
</script>

<template>
  <div class="science-page">
    <header class="science-header">
      <div class="science-header-inner">
        <router-link to="/" class="science-back">
          <span class="science-back-icon" aria-hidden="true">←</span>
          <span>Wiki Loves</span>
        </router-link>
      </div>
    </header>

    <main class="science-main">
      <section class="science-hero">
        <span class="science-hero-label">Photo competition</span>
        <h1 class="science-title">{{ scienceData.campaign_name }}</h1>
        <p class="science-tagline">
          Participation, uploads, and usage across Wikimedia wikis — explore by year below.
        </p>
        <div class="science-hero-line" aria-hidden="true" />
      </section>

      <section class="science-milestones">
        <h2 class="science-milestones-heading">Key numbers</h2>
        <div class="science-milestones-grid">
          <div class="milestone">
            <span class="milestone-value">{{ formatNumber(displayStats.uploads) }}</span>
            <span class="milestone-label">{{ selectedYear == null ? 'Total uploads' : 'Uploads' }}</span>
          </div>
          <div class="milestone">
            <span class="milestone-value">{{ displayStats.years }}</span>
            <span class="milestone-label">{{ selectedYear == null ? 'Editions' : 'Year' }}</span>
          </div>
          <div class="milestone">
            <span class="milestone-value">{{ formatNumber(displayStats.uploaders) }}</span>
            <span class="milestone-label">Uploaders</span>
          </div>
          <div class="milestone">
            <span class="milestone-value">{{ displayStats.countries }}</span>
            <span class="milestone-label">{{ selectedYear == null ? 'Countries (max)' : 'Countries' }}</span>
          </div>
        </div>
      </section>

      <section class="science-timeline-section">
        <h2 class="science-timeline-title">Explore by year</h2>
        <div class="science-timeline-track">
          <button
            type="button"
            class="science-timeline-btn"
            :class="{ active: selectedYear === null }"
            @click="selectedYear = null"
          >
            All
          </button>
          <span class="science-timeline-connector" />
          <router-link
            v-for="y in sortedYears"
            :key="y.year"
            :to="`/science/${y.year}`"
            class="science-timeline-btn"
          >
            {{ y.year }}
          </router-link>
        </div>
      </section>

      <section class="science-table-section">
        <h2 class="science-section-title">Yearly breakdown</h2>
        <div class="science-table-wrap">
          <table class="science-table">
            <thead>
              <tr>
                <th>Year</th>
                <th>Countries</th>
                <th>Uploads</th>
                <th>Images used in wikis</th>
                <th>Uploaders</th>
                <th>New uploaders</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="row in tableRows" :key="row.year" :class="{ 'row-selected': selectedYear === row.year }">
                <td class="cell-year">{{ row.year }}</td>
                <td class="cell-num">{{ formatNumber(row.countries) }}</td>
                <td class="cell-num">{{ formatNumber(row.uploads) }}</td>
                <td class="cell-num">
                  {{ formatNumber(row.images_used) }}
                  <span v-if="row.images_used_pct != null" class="cell-pct">{{ formatPercent(row.images_used_pct) }}</span>
                </td>
                <td class="cell-num">{{ formatNumber(row.uploaders) }}</td>
                <td class="cell-num">
                  {{ formatNumber(row.new_uploaders) }}
                  <span v-if="row.new_uploaders_pct != null" class="cell-pct">{{ formatPercent(row.new_uploaders_pct) }}</span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <p class="science-meta">Static data · Updated {{ scienceData.updated }}</p>
      </section>
    </main>

    <footer class="science-footer">
      <router-link to="/" class="science-footer-link">Back to Wiki Loves</router-link>
    </footer>
  </div>
</template>

<style scoped>
.science-page {
  min-height: 100vh;
  background: linear-gradient(180deg, #f5f4f0 0%, #ebe8e2 50%, #f8f7f4 100%);
  color: #1a1a1a;
}

.science-header {
  background: rgba(255, 255, 255, 0.85);
  backdrop-filter: blur(8px);
  border-bottom: 1px solid rgba(0, 0, 0, 0.06);
}

.science-header-inner {
  max-width: 1100px;
  margin: 0 auto;
  padding: 1rem 1.5rem;
}

.science-back {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  color: #991b1b;
  text-decoration: none;
  font-weight: 600;
  font-size: 0.9375rem;
  transition: color 0.2s ease;
}

.science-back:hover {
  color: #7f1d1d;
}

.science-back-icon {
  font-size: 1.1rem;
}

.science-main {
  max-width: 1100px;
  margin: 0 auto;
  padding: 0 1.5rem 3rem;
}

.science-hero {
  margin-bottom: 3rem;
  padding: 3rem 0 2.5rem;
}

.science-hero-label {
  display: block;
  font-size: 0.8125rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.15em;
  color: #991b1b;
  margin-bottom: 0.75rem;
}

.science-title {
  margin: 0 0 0.75rem;
  font-family: Georgia, 'Times New Roman', serif;
  font-size: clamp(2.25rem, 6vw, 3.25rem);
  font-weight: 700;
  letter-spacing: -0.02em;
  color: #0f172a;
  line-height: 1.15;
}

.science-tagline {
  margin: 0 0 1.5rem;
  font-size: 1.125rem;
  line-height: 1.65;
  color: #475569;
  max-width: 520px;
}

.science-hero-line {
  width: 3rem;
  height: 3px;
  background: linear-gradient(90deg, #991b1b, #b91c1c);
  border-radius: 2px;
}

.science-milestones {
  margin-bottom: 3rem;
  padding: 2rem 2.25rem;
  background: #fff;
  border-radius: 16px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06), 0 1px 3px rgba(0, 0, 0, 0.04);
  border: 1px solid rgba(0, 0, 0, 0.06);
}

.science-milestones-heading {
  margin: 0 0 1.75rem;
  font-family: Georgia, 'Times New Roman', serif;
  font-size: 1.5rem;
  font-weight: 700;
  color: #991b1b;
  letter-spacing: 0.02em;
}

.science-milestones-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 2rem;
}

.milestone {
  display: flex;
  flex-direction: column;
  gap: 0.4rem;
}

.milestone-value {
  font-size: 2.25rem;
  font-weight: 800;
  color: #0f172a;
  font-variant-numeric: tabular-nums;
  letter-spacing: -0.03em;
  line-height: 1.1;
}

.milestone-label {
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.08em;
  color: #64748b;
}

.science-timeline-section {
  margin-bottom: 2.5rem;
}

.science-timeline-title {
  margin: 0 0 1rem;
  font-size: 0.9375rem;
  font-weight: 600;
  color: #475569;
  text-transform: uppercase;
  letter-spacing: 0.06em;
}

.science-timeline-track {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 0.35rem;
}

.science-timeline-connector {
  width: 1px;
  height: 1.25rem;
  background: #cbd5e1;
  margin: 0 0.15rem;
  flex-shrink: 0;
}

.science-timeline-btn {
  padding: 0.5rem 1rem;
  border: 2px solid #e2e8f0;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  background: #fff;
  color: #475569;
  transition: all 0.2s ease;
  display: inline-block;
  text-decoration: none;
}

a.science-timeline-btn:hover {
  border-color: #991b1b;
  color: #991b1b;
  background: #fef2f2;
}

.science-timeline-btn:hover {
  border-color: #991b1b;
  color: #991b1b;
  background: #fef2f2;
}

.science-timeline-btn.active {
  background: #991b1b;
  border-color: #991b1b;
  color: #fff;
}

.science-timeline-btn.active:hover,
a.science-timeline-btn.router-link-active:hover {
  background: #7f1d1d;
  border-color: #7f1d1d;
}

a.science-timeline-btn.router-link-active {
  background: #991b1b;
  border-color: #991b1b;
  color: #fff;
}

.science-table-section {
  margin-bottom: 2rem;
}

.science-section-title {
  margin: 0 0 1rem;
  font-size: 1.125rem;
  font-weight: 600;
  color: #334155;
  letter-spacing: 0.02em;
}

.science-table-wrap {
  overflow-x: auto;
  border-radius: 12px;
  box-shadow: 0 4px 24px rgba(0, 0, 0, 0.06);
  background: #fff;
}

.science-table {
  width: 100%;
  border-collapse: collapse;
  font-size: 0.9375rem;
}

.science-table thead tr {
  background: #1e293b;
}

.science-table th {
  padding: 1rem 1.25rem;
  text-align: left;
  font-weight: 600;
  color: #f8fafc;
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.06em;
}

.science-table th:first-child {
  border-radius: 12px 0 0 0;
}

.science-table th:last-child {
  border-radius: 0 12px 0 0;
}

.science-table td {
  padding: 1rem 1.25rem;
  border-bottom: 1px solid #f1f5f9;
  color: #334155;
}

.science-table tbody tr:last-child td {
  border-bottom: none;
}

.science-table tbody tr:hover {
  background: #f8fafc;
}

.science-table tbody tr.row-selected {
  background: #fef2f2;
}

.cell-year {
  font-weight: 700;
  color: #0f172a;
}

.cell-num {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

.cell-pct {
  margin-left: 0.35rem;
  color: #64748b;
  font-weight: 400;
}

.science-meta {
  margin: 1rem 0 0;
  font-size: 0.8125rem;
  color: #94a3b8;
}

.science-footer {
  max-width: 1100px;
  margin: 0 auto;
  padding: 2rem 1.5rem;
  border-top: 2px solid rgba(153, 27, 27, 0.2);
  text-align: center;
  background: rgba(255, 255, 255, 0.7);
}

.science-footer-link {
  color: #991b1b;
  text-decoration: none;
  font-weight: 600;
  font-size: 0.9375rem;
}

.science-footer-link:hover {
  text-decoration: underline;
}

@media (max-width: 768px) {
  .science-main {
    padding: 0 1rem 2rem;
  }

  .science-hero {
    padding: 2rem 0 1.5rem;
  }

  .science-milestones {
    padding: 1.5rem 1.25rem;
  }

  .science-milestones-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 1.5rem;
  }

  .milestone-value {
    font-size: 1.75rem;
  }

  .science-timeline-connector {
    display: none;
  }

  .science-table th,
  .science-table td {
    padding: 0.75rem 1rem;
    font-size: 0.875rem;
  }
}

@media (max-width: 480px) {
  .science-milestones-grid {
    grid-template-columns: 1fr;
  }
}
</style>
