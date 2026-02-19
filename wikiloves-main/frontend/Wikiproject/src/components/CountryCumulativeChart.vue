<script setup>
import { computed } from 'vue'

const MONTH_LABELS = ['Jun', 'Jul', 'Aug', 'Sep']

// Cumulative share of total at each month end (0 = start Jun, 1 = end Jun, 2 = end Jul, 3 = end Sep)
const CUMULATIVE_SHARES = [0, 0.12, 0.35, 0.72, 1]

const props = defineProps({
  countryRows: {
    type: Array,
    required: true,
    default: () => []
  },
  height: {
    type: Number,
    default: 280
  },
  padding: {
    type: Object,
    default: () => ({ top: 24, right: 24, bottom: 44, left: 52 })
  },
  maxCountries: {
    type: Number,
    default: 18
  },
  colors: {
    type: Array,
    default: () => [
      '#16a34a', '#2563eb', '#9333ea', '#ca8a04', '#dc2626', '#0891b2', '#c026d3',
      '#65a30d', '#4f46e5', '#ea580c', '#0d9488', '#be185d', '#84cc16', '#7c3aed',
      '#0ea5e9', '#e11d48', '#4ade80', '#a16207'
    ]
  }
})

const chartWidth = computed(() => 800)
const innerWidth = computed(() => chartWidth.value - props.padding.left - props.padding.right)
const innerHeight = computed(() => chartHeight.value - props.padding.top - props.padding.bottom)
const chartHeight = computed(() => props.height)

const countriesWithSeries = computed(() => {
  const rows = (props.countryRows || []).slice(0, props.maxCountries)
  return rows.map((row) => {
    const total = Number(row.images) || 0
    const data = CUMULATIVE_SHARES.map((share, i) => ({
      monthIndex: i,
      label: i === 0 ? null : MONTH_LABELS[i - 1],
      cumulative: Math.round(share * total)
    }))
    return { name: row.country, total, data }
  })
})

const maxCumulative = computed(() => {
  if (countriesWithSeries.value.length === 0) return 1000
  const max = Math.max(...countriesWithSeries.value.map((c) => c.total))
  const step = max <= 2000 ? 500 : max <= 10000 ? 2000 : 4000
  return Math.ceil(max / step) * step || 1000
})

const xScale = (monthIndex) => {
  const n = CUMULATIVE_SHARES.length
  if (n <= 1) return innerWidth.value / 2
  return (monthIndex / (n - 1)) * innerWidth.value
}

const yScale = (value) => {
  return innerHeight.value - (value / maxCumulative.value) * innerHeight.value
}

const getColor = (index) => props.colors[index % props.colors.length]

const getPathD = (country) => {
  const data = country.data
  if (data.length === 0) return ''
  const points = data.map((d) => {
    const x = props.padding.left + xScale(d.monthIndex)
    const y = props.padding.top + yScale(d.cumulative)
    return `${x},${y}`
  })
  return `M ${points.join(' L ')}`
}

const formatY = (v) => {
  if (v >= 1000) return `${(v / 1000).toFixed(0)}k`
  return String(v)
}

const yTicks = computed(() => {
  const max = maxCumulative.value
  const count = 6
  return Array.from({ length: count + 1 }, (_, i) => (i / count) * max)
})
</script>

<template>
  <div class="country-cumulative-chart">
    <svg
      :width="chartWidth"
      :height="chartHeight"
      class="chart-svg"
      viewBox="0 0 800 280"
      preserveAspectRatio="xMidYMid meet"
      aria-label="Cumulative uploads by country over competition period"
    >
      <!-- Grid -->
      <g class="grid">
        <line
          v-for="(val, i) in yTicks"
          :key="`h-${i}`"
          :x1="padding.left"
          :y1="padding.top + yScale(val)"
          :x2="chartWidth - padding.right"
          :y2="padding.top + yScale(val)"
          class="grid-line"
        />
      </g>
      <!-- Country lines -->
      <g class="lines">
        <path
          v-for="(country, idx) in countriesWithSeries"
          :key="country.name"
          :d="getPathD(country)"
          :stroke="getColor(idx)"
          stroke-width="2"
          fill="none"
          stroke-linecap="round"
          stroke-linejoin="round"
          class="country-line"
        />
      </g>
      <!-- Y-axis labels -->
      <g class="y-axis">
        <text
          v-for="(val, i) in yTicks"
          :key="`y-${i}`"
          :x="padding.left - 8"
          :y="padding.top + yScale(val) + 4"
          class="axis-label"
          text-anchor="end"
        >
          {{ formatY(val) }}
        </text>
      </g>
      <!-- X-axis labels -->
      <g class="x-axis">
        <text
          v-for="(label, i) in MONTH_LABELS"
          :key="label"
          :x="padding.left + ((i + 0.5) / 4) * innerWidth"
          :y="chartHeight - padding.bottom + 20"
          class="axis-label"
          text-anchor="middle"
        >
          {{ label }}
        </text>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.country-cumulative-chart {
  width: 100%;
  overflow-x: auto;
}

.chart-svg {
  display: block;
  width: 100%;
  height: auto;
  min-width: 320px;
}

.grid-line {
  stroke: #e5e7eb;
  stroke-width: 1;
}

.country-line {
  transition: stroke-width 0.15s ease, opacity 0.15s ease;
}

.country-line:hover {
  stroke-width: 3;
  opacity: 0.95;
}

.axis-label {
  font-size: 11px;
  fill: #6b7280;
  font-variant-numeric: tabular-nums;
}
</style>
