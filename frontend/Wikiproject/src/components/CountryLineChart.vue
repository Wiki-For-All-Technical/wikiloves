<script setup>
import { computed } from 'vue'

const props = defineProps({
  yearlyStats: {
    type: Array,
    required: true,
    default: () => []
  },
  height: {
    type: Number,
    default: 400
  },
  padding: {
    type: Object,
    default: () => ({ top: 40, right: 40, bottom: 60, left: 60 })
  }
})

// Aggregate country data across all years
const countryData = computed(() => {
  const countryMap = new Map()
  
  // Sort years from oldest to newest
  const sortedYears = [...props.yearlyStats].sort((a, b) => a.year - b.year)
  
  sortedYears.forEach((yearEntry) => {
    if (!yearEntry.country_stats) return
    
    yearEntry.country_stats.forEach((countryStat) => {
      const countryName = countryStat.name
      if (!countryMap.has(countryName)) {
        countryMap.set(countryName, {
          name: countryName,
          data: []
        })
      }
      
      const country = countryMap.get(countryName)
      const previousTotal = country.data.length > 0 
        ? country.data[country.data.length - 1].cumulative 
        : 0
      
      country.data.push({
        year: yearEntry.year,
        uploads: countryStat.uploads || 0,
        cumulative: previousTotal + (countryStat.uploads || 0)
      })
    })
  })
  
  // Convert to array and sort by final cumulative value (descending)
  return Array.from(countryMap.values())
    .map(country => ({
      ...country,
      finalCumulative: country.data.length > 0 
        ? country.data[country.data.length - 1].cumulative 
        : 0
    }))
    .sort((a, b) => b.finalCumulative - a.finalCumulative)
    .slice(0, 20) // Show top 20 countries
})

const allYears = computed(() => {
  const years = [...props.yearlyStats]
    .map(e => e.year)
    .sort((a, b) => a - b)
  return years
})

const maxValue = computed(() => {
  if (countryData.value.length === 0) return 1
  const maxCumulative = Math.max(
    ...countryData.value.map(c => 
      Math.max(...c.data.map(d => d.cumulative))
    )
  )
  return Math.ceil(maxCumulative / 2000) * 2000 || 1
})

const chartWidth = computed(() => 1000)
const chartHeight = computed(() => props.height)

const innerWidth = computed(() => {
  return chartWidth.value - props.padding.left - props.padding.right
})

const innerHeight = computed(() => {
  return chartHeight.value - props.padding.top - props.padding.bottom
})

const xScale = computed(() => {
  if (allYears.value.length === 0) return () => 0
  if (allYears.value.length === 1) return () => innerWidth.value / 2
  return (year) => {
    const index = allYears.value.indexOf(year)
    return (index / (allYears.value.length - 1)) * innerWidth.value
  }
})

const yScale = computed(() => {
  return (value) => {
    return innerHeight.value - ((value / maxValue.value) * innerHeight.value)
  }
})

// Color palette for lines
const colors = [
  '#84cc16', // Olive green
  '#f97316', // Orange
  '#ec4899', // Pink/Magenta
  '#3b82f6', // Blue
  '#8b5cf6', // Purple
  '#14b8a6', // Teal
  '#f59e0b', // Amber
  '#ef4444', // Red
  '#06b6d4', // Cyan
  '#10b981', // Green
  '#6366f1', // Indigo
  '#f43f5e', // Rose
  '#22c55e', // Green
  '#a855f7', // Purple
  '#eab308', // Yellow
  '#06b6d4', // Sky
  '#f97316', // Orange
  '#84cc16', // Lime
  '#ec4899', // Pink
  '#3b82f6'  // Blue
]

const getCountryColor = (index) => {
  return colors[index % colors.length]
}

const getPathData = (country) => {
  if (country.data.length === 0) return ''
  if (country.data.length === 1) {
    const point = country.data[0]
    const x = props.padding.left + xScale.value(point.year)
    const y = props.padding.top + yScale.value(point.cumulative)
    return `M ${x} ${y} L ${x} ${y}`
  }
  
  let path = ''
  country.data.forEach((point, index) => {
    const x = props.padding.left + xScale.value(point.year)
    const y = props.padding.top + yScale.value(point.cumulative)
    
    if (index === 0) {
      path = `M ${x} ${y}`
    } else {
      const prevPoint = country.data[index - 1]
      const prevX = props.padding.left + xScale.value(prevPoint.year)
      const prevY = props.padding.top + yScale.value(prevPoint.cumulative)
      const midX = (prevX + x) / 2
      path += ` Q ${prevX} ${prevY}, ${midX} ${(prevY + y) / 2} T ${x} ${y}`
    }
  })
  
  return path
}

const formatValue = (value) => {
  if (value >= 1000000) return `${(value / 1000000).toFixed(1)}M`
  if (value >= 1000) return `${(value / 1000).toFixed(1)}K`
  return value.toString()
}
</script>

<template>
  <div class="country-line-chart-container">
    <div class="chart-header">
      <h3 class="chart-title">Tool Labs – Tools for Wiki Loves Photo Competitions</h3>
      <div class="chart-date">{{ new Date().toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric' }) }}</div>
    </div>
    <svg
      :width="chartWidth"
      :height="chartHeight"
      class="country-line-chart"
      viewBox="0 0 1000 400"
      preserveAspectRatio="xMidYMid meet"
    >
      <!-- Grid lines -->
      <g class="grid-lines">
        <line
          v-for="(value, index) in Array.from({ length: 7 }, (_, i) => (i * maxValue.value) / 6)"
          :key="`grid-${index}`"
          :x1="padding.left"
          :y1="padding.top + yScale(value)"
          :x2="chartWidth - padding.right"
          :y2="padding.top + yScale(value)"
          class="grid-line"
        />
      </g>
      
      <!-- Country lines -->
      <g class="country-lines">
        <path
          v-for="(country, index) in countryData"
          :key="`line-${country.name}`"
          :d="getPathData(country)"
          :stroke="getCountryColor(index)"
          stroke-width="2"
          fill="none"
          class="country-line"
          :data-country="country.name"
        />
      </g>
      
      <!-- Data points -->
      <g class="data-points">
        <template v-for="(country, countryIndex) in countryData" :key="country.name">
          <circle
            v-for="point in country.data"
            :key="`${country.name}-${point.year}`"
            :cx="padding.left + xScale(point.year)"
            :cy="padding.top + yScale(point.cumulative)"
            r="3"
            :fill="getCountryColor(countryIndex)"
            stroke="white"
            stroke-width="1.5"
            class="data-point"
          >
            <title>{{ country.name }}: {{ formatValue(point.cumulative) }} ({{ point.year }})</title>
          </circle>
        </template>
      </g>
      
      <!-- Y-axis labels -->
      <g class="y-axis">
        <text
          v-for="(value, index) in Array.from({ length: 7 }, (_, i) => (i * maxValue.value) / 6)"
          :key="`y-label-${index}`"
          :x="padding.left - 10"
          :y="padding.top + yScale(value) + 4"
          class="axis-label y-label"
          text-anchor="end"
        >
          {{ formatValue(value) }}
        </text>
      </g>
      
      <!-- X-axis labels -->
      <g class="x-axis">
        <text
          v-for="year in allYears"
          :key="`x-label-${year}`"
          :x="padding.left + xScale(year)"
          :y="chartHeight - padding.bottom + 20"
          class="axis-label x-label"
          text-anchor="middle"
        >
          {{ year }}
        </text>
      </g>
    </svg>
    
    <!-- Legend -->
    <div class="chart-legend">
      <div
        v-for="(country, index) in countryData.slice(0, 10)"
        :key="country.name"
        class="legend-item"
      >
        <span
          class="legend-color"
          :style="{ backgroundColor: getCountryColor(index) }"
        ></span>
        <span class="legend-label">{{ country.name }}</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.country-line-chart-container {
  width: 100%;
  overflow-x: auto;
  padding: 1rem 0;
}

.chart-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
  padding: 0 1rem;
}

.chart-title {
  font-size: 1.125rem;
  font-weight: 600;
  color: #111827;
  margin: 0;
}

.chart-date {
  font-size: 0.875rem;
  color: #6b7280;
}

.country-line-chart {
  display: block;
  width: 100%;
  height: auto;
  min-width: 1000px;
}

.grid-lines {
  opacity: 0.2;
}

.grid-line {
  stroke: #9ca3af;
  stroke-width: 1;
  stroke-dasharray: 2, 2;
}

.country-line {
  transition: stroke-width 0.2s ease;
  cursor: pointer;
}

.country-line:hover {
  stroke-width: 3;
  opacity: 0.9;
}

.data-point {
  cursor: pointer;
  transition: r 0.2s ease;
}

.data-point:hover {
  r: 5;
  filter: brightness(1.2);
}

.axis-label {
  font-size: 11px;
  fill: #6b7280;
  font-weight: 500;
}

.y-label {
  dominant-baseline: middle;
}

.x-label {
  dominant-baseline: hanging;
}

.chart-legend {
  display: flex;
  flex-wrap: wrap;
  gap: 1rem;
  margin-top: 1rem;
  padding: 1rem;
  background: #f9fafb;
  border-radius: 6px;
  font-size: 0.8125rem;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
}

.legend-color {
  width: 12px;
  height: 12px;
  border-radius: 2px;
  display: inline-block;
}

.legend-label {
  color: #374151;
  font-weight: 500;
}

@media (max-width: 768px) {
  .country-line-chart {
    min-width: 800px;
  }
  
  .axis-label {
    font-size: 10px;
  }
  
  .chart-legend {
    font-size: 0.75rem;
    gap: 0.75rem;
  }
}
</style>

