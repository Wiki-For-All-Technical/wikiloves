<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import CountryBarChart from './CountryBarChart.vue'

const props = defineProps({
  yearlyStats: {
    type: Array,
    required: true,
    default: () => []
  },
  campaignSlug: {
    type: String,
    required: true
  }
})

const route = useRoute()

// Aggregate country data across all years
const countryDataMap = computed(() => {
  const map = new Map()
  
  props.yearlyStats.forEach((yearEntry) => {
    if (!yearEntry.country_stats || !Array.isArray(yearEntry.country_stats)) return
    
    yearEntry.country_stats.forEach((countryStat) => {
      const countryName = countryStat.name
      
      if (!map.has(countryName)) {
        map.set(countryName, {
          name: countryName,
          years: []
        })
      }
      
      const country = map.get(countryName)
      country.years.push({
        year: yearEntry.year,
        uploads: countryStat.uploads || 0,
        images_used: countryStat.images_used || 0,
        uploaders: countryStat.uploaders || 0,
        new_uploaders: countryStat.new_uploaders || 0,
        images_used_pct: countryStat.images_used_pct || 0,
        new_uploaders_pct: countryStat.new_uploaders_pct || 0
      })
    })
  })
  
  // Sort years for each country
  map.forEach((country) => {
    country.years.sort((a, b) => a.year - b.year)
  })
  
  // Convert to array and sort alphabetically by country name
  return Array.from(map.values()).sort((a, b) => {
    return a.name.localeCompare(b.name)
  })
})

const formatNum = (num) => {
  return new Intl.NumberFormat('en-US').format(num)
}

const getYearUrl = (year) => {
  return `/${route.params.segment}/${year}`
}

const getCountryYearUrl = (countryName, year) => {
  return `/${route.params.segment}/${year}/${countryName}`
}

const getImagesUrl = (countryName, year) => {
  return `/images?event=${props.campaignSlug}&year=${year}&country=${encodeURIComponent(countryName)}`
}

const getUsersUrl = (countryName, year) => {
  return `/${route.params.segment}/${year}/${countryName}/users`
}
</script>

<template>
  <section class="country-stats-section" v-if="countryDataMap.length > 0">
    <div class="section-header">
      <h2>Below are the graphs per country.</h2>
    </div>
    
    <div class="countries-list">
      <div
        v-for="country in countryDataMap"
        :key="country.name"
        class="country-block"
      >
        <h3 class="country-name">{{ country.name }}</h3>
        
        <!-- Bar Chart -->
        <div class="country-chart-wrapper" v-if="country.years.length > 0">
          <CountryBarChart
            :country-name="country.name"
            :year-data="country.years"
            :height="250"
          />
        </div>
        
        <!-- Year-by-year table -->
        <div class="country-table-wrapper" v-if="country.years.length > 0">
          <table class="country-table">
            <thead>
              <tr>
                <th class="year-col">Year</th>
                <th class="num-col">Uploads</th>
                <th class="num-col">Images used in the wikis</th>
                <th class="num-col">Uploaders</th>
                <th class="num-col">Uploaders registered after competition start</th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="yearEntry in country.years" :key="yearEntry.year">
                <td class="year-col">
                  <router-link :to="getYearUrl(yearEntry.year)" class="year-link">
                    {{ yearEntry.year }}
                  </router-link>
                </td>
                <td class="num-col">
                  <a
                    :href="getImagesUrl(country.name, yearEntry.year)"
                    class="uploads-link"
                  >
                    {{ formatNum(yearEntry.uploads) }}
                  </a>
                </td>
                <td class="num-col">
                  {{ formatNum(yearEntry.images_used) }}
                  <span class="percentage">({{ Math.round(yearEntry.images_used_pct || 0) }}%)</span>
                </td>
                <td class="num-col">
                  <router-link
                    :to="getUsersUrl(country.name, yearEntry.year)"
                    class="uploaders-link"
                  >
                    {{ formatNum(yearEntry.uploaders) }}
                  </router-link>
                </td>
                <td class="num-col">
                  <span v-if="yearEntry.new_uploaders > 0">
                    {{ formatNum(yearEntry.new_uploaders) }}
                    <span class="percentage">({{ Math.round(yearEntry.new_uploaders_pct || 0) }}%)</span>
                  </span>
                  <span v-else>— <span class="percentage">(0%)</span></span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.country-stats-section {
  margin-top: 4rem;
  padding: 2rem;
  background: linear-gradient(135deg, var(--bg-card, #ffffff) 0%, var(--bg-secondary, #f9fafb) 100%);
  border-radius: 12px;
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
  border: 1px solid var(--border-color, #e5e7eb);
}

.section-header {
  margin-bottom: 3rem;
}

.section-header h2 {
  margin: 0;
  color: var(--text-primary, #111827);
  font-size: 1.5rem;
  font-weight: 700;
  text-align: center;
}

.countries-list {
  display: flex;
  flex-direction: column;
  gap: 3rem;
}

.country-block {
  background: var(--bg-primary, #ffffff);
  padding: 2rem;
  border-radius: 8px;
  border: 1px solid var(--border-color, #e5e7eb);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.country-name {
  margin: 0 0 1.5rem 0;
  padding-bottom: 0.75rem;
  border-bottom: 2px solid var(--border-color, #e5e7eb);
  color: var(--text-primary, #111827);
  font-size: 1.375rem;
  font-weight: 700;
}

.country-chart-wrapper {
  margin-bottom: 2rem;
  padding: 1rem;
  background: #f9fafb;
  border-radius: 6px;
}

.country-table-wrapper {
  overflow-x: auto;
  border-radius: 6px;
  border: 1px solid var(--border-color, #e5e7eb);
}

.country-table {
  width: 100%;
  border-collapse: separate;
  border-spacing: 0;
  font-size: 0.9375rem;
}

.country-table thead {
  position: sticky;
  top: 0;
  z-index: 10;
}

.country-table th {
  text-align: left;
  padding: 1rem 0.875rem;
  background: linear-gradient(135deg, var(--bg-secondary, #f9fafb) 0%, var(--bg-hover, #f3f4f6) 100%);
  color: var(--text-secondary, #374151);
  font-weight: 700;
  font-size: 0.8125rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  border-bottom: 2px solid var(--border-color, #e5e7eb);
  white-space: nowrap;
}

.country-table th:first-child {
  border-top-left-radius: 6px;
}

.country-table th:last-child {
  border-top-right-radius: 6px;
}

.country-table td {
  padding: 0.875rem;
  border-bottom: 1px solid var(--border-color, #f3f4f6);
  transition: all 0.2s ease;
  color: var(--text-primary, #1f2937);
}

.country-table tbody tr {
  transition: all 0.2s ease;
}

.country-table tbody tr:nth-child(even) {
  background-color: var(--bg-secondary, #f9fafb);
}

.country-table tbody tr:hover {
  background-color: var(--bg-hover, #f3f4f6);
}

.country-table tbody tr:last-child td {
  border-bottom: none;
}

.country-table tbody tr:last-child td:first-child {
  border-bottom-left-radius: 6px;
}

.country-table tbody tr:last-child td:last-child {
  border-bottom-right-radius: 6px;
}

.year-col {
  text-align: center;
  width: 80px;
  font-weight: 700;
}

.num-col {
  text-align: right;
  font-variant-numeric: tabular-nums;
  font-weight: 600;
  color: var(--text-primary, #1f2937);
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

.uploads-link,
.uploaders-link {
  color: #059669;
  text-decoration: none;
  font-weight: 600;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  transition: all 0.2s ease;
  display: inline-block;
}

.uploads-link:hover,
.uploaders-link:hover {
  background-color: #ecfdf5;
  color: #047857;
  transform: scale(1.05);
}

.percentage {
  color: var(--text-secondary, #6b7280);
  font-weight: 400;
  font-size: 0.875rem;
  margin-left: 0.25rem;
}

@media (max-width: 768px) {
  .country-stats-section {
    padding: 1.5rem;
  }
  
  .country-block {
    padding: 1.5rem;
  }
  
  .country-name {
    font-size: 1.25rem;
  }
  
  .country-table {
    font-size: 0.875rem;
  }
  
  .country-table th,
  .country-table td {
    padding: 0.75rem 0.5rem;
  }
}
</style>

