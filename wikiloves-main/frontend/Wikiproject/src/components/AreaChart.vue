<script setup>
import { computed } from 'vue'

const props = defineProps({
  data: {
    type: Array,
    required: true,
    default: () => []
  },
  color: {
    type: String,
    default: '#dc2626'
  },
  fillColor: {
    type: String,
    default: '#fecaca'
  },
  height: {
    type: Number,
    default: 300
  },
  padding: {
    type: Object,
    default: () => ({ top: 20, right: 20, bottom: 50, left: 50 })
  }
})

const chartData = computed(() => {
  if (!props.data || props.data.length === 0) return []
  return props.data.map((item, index) => ({
    ...item,
    index
  }))
})

const maxValue = computed(() => {
  if (chartData.value.length === 0) return 1
  const values = chartData.value.map(d => d.value || d.uploads || 0)
  const max = Math.max(...values)
  // Round up to nearest nice number
  return Math.ceil(max / 2) * 2
})

const minValue = computed(() => {
  return 0
})

const chartWidth = computed(() => {
  return 800
})

const chartHeight = computed(() => props.height)

const innerWidth = computed(() => {
  return chartWidth.value - props.padding.left - props.padding.right
})

const innerHeight = computed(() => {
  return chartHeight.value - props.padding.top - props.padding.bottom
})

const xScale = computed(() => {
  if (chartData.value.length === 0) return () => 0
  return (index) => {
    if (chartData.value.length === 1) return innerWidth.value / 2
    return (index / (chartData.value.length - 1)) * innerWidth.value
  }
})

const yScale = computed(() => {
  const range = maxValue.value - minValue.value
  if (range === 0) return () => innerHeight.value
  return (value) => {
    const normalized = (value - minValue.value) / range
    return innerHeight.value - (normalized * innerHeight.value)
  }
})

const pathData = computed(() => {
  if (chartData.value.length === 0) return ''
  
  const points = chartData.value.map((item, index) => {
    const value = item.value || item.uploads || 0
    const x = props.padding.left + xScale.value(index)
    const y = props.padding.top + yScale.value(value)
    return { x, y, value }
  })
  
  if (points.length === 0) return ''
  if (points.length === 1) {
    const p = points[0]
    return `M ${p.x} ${innerHeight.value + props.padding.top} L ${p.x} ${p.y} L ${p.x} ${innerHeight.value + props.padding.top}`
  }
  
  // Create smooth curve using quadratic bezier
  let path = `M ${points[0].x} ${innerHeight.value + props.padding.top}`
  path += ` L ${points[0].x} ${points[0].y}`
  
  for (let i = 0; i < points.length - 1; i++) {
    const current = points[i]
    const next = points[i + 1]
    const midX = (current.x + next.x) / 2
    path += ` Q ${current.x} ${current.y}, ${midX} ${(current.y + next.y) / 2}`
    path += ` T ${next.x} ${next.y}`
  }
  
  const last = points[points.length - 1]
  path += ` L ${last.x} ${innerHeight.value + props.padding.top} Z`
  
  return path
})

const linePath = computed(() => {
  if (chartData.value.length === 0) return ''
  
  const points = chartData.value.map((item, index) => {
    const value = item.value || item.uploads || 0
    const x = props.padding.left + xScale.value(index)
    const y = props.padding.top + yScale.value(value)
    return { x, y, value }
  })
  
  if (points.length === 0) return ''
  if (points.length === 1) {
    return `M ${points[0].x} ${points[0].y}`
  }
  
  let path = `M ${points[0].x} ${points[0].y}`
  
  for (let i = 0; i < points.length - 1; i++) {
    const current = points[i]
    const next = points[i + 1]
    const midX = (current.x + next.x) / 2
    path += ` Q ${current.x} ${current.y}, ${midX} ${(current.y + next.y) / 2}`
    path += ` T ${next.x} ${next.y}`
  }
  
  return path
})

const yAxisLabels = computed(() => {
  const step = Math.ceil(maxValue.value / 8)
  const labels = []
  for (let i = 0; i <= maxValue.value; i += step) {
    labels.push(i)
  }
  return labels
})

const formatLabel = (item) => {
  if (item.label) return item.label
  if (item.year) return item.year.toString()
  if (item.date) return item.date
  return ''
}

const formatValue = (value) => {
  if (value >= 1000000) return `${(value / 1000000).toFixed(1)}M`
  if (value >= 1000) return `${(value / 1000).toFixed(1)}K`
  return value.toString()
}
</script>

<template>
  <div class="area-chart-container">
    <svg
      :width="chartWidth"
      :height="chartHeight"
      class="area-chart"
      viewBox="0 0 800 300"
      preserveAspectRatio="xMidYMid meet"
    >
      <!-- Grid lines -->
      <g class="grid-lines">
        <line
          v-for="(label, index) in yAxisLabels"
          :key="`grid-${index}`"
          :x1="padding.left"
          :y1="padding.top + yScale(label)"
          :x2="chartWidth - padding.right"
          :y2="padding.top + yScale(label)"
          class="grid-line"
        />
      </g>
      
      <!-- Area fill -->
      <path
        :d="pathData"
        :fill="fillColor"
        class="area-fill"
        opacity="0.6"
      />
      
      <!-- Line -->
      <path
        :d="linePath"
        :stroke="color"
        stroke-width="2.5"
        fill="none"
        class="area-line"
      />
      
      <!-- Data points -->
      <g class="data-points">
        <circle
          v-for="(item, index) in chartData"
          :key="`point-${index}`"
          :cx="padding.left + xScale(index)"
          :cy="padding.top + yScale(item.value || item.uploads || 0)"
          r="4"
          :fill="color"
          stroke="white"
          stroke-width="2"
          class="data-point"
        >
          <title>{{ formatValue(item.value || item.uploads || 0) }}</title>
        </circle>
      </g>
      
      <!-- Y-axis labels -->
      <g class="y-axis">
        <text
          v-for="(label, index) in yAxisLabels"
          :key="`y-label-${index}`"
          :x="padding.left - 10"
          :y="padding.top + yScale(label) + 4"
          class="axis-label y-label"
          text-anchor="end"
        >
          {{ label }}
        </text>
      </g>
      
      <!-- X-axis labels -->
      <g class="x-axis">
        <text
          v-for="(item, index) in chartData"
          :key="`x-label-${index}`"
          :x="padding.left + xScale(index)"
          :y="chartHeight - padding.bottom + 20"
          class="axis-label x-label"
          text-anchor="middle"
          :transform="`rotate(-45 ${padding.left + xScale(index)} ${chartHeight - padding.bottom + 20})`"
        >
          {{ formatLabel(item) }}
        </text>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.area-chart-container {
  width: 100%;
  overflow-x: auto;
  padding: 1rem 0;
}

.area-chart {
  display: block;
  width: 100%;
  height: auto;
  min-width: 800px;
}

.grid-lines {
  opacity: 0.3;
}

.grid-line {
  stroke: #d1d5db;
  stroke-width: 1;
  stroke-dasharray: 2, 2;
}

.area-fill {
  transition: opacity 0.3s ease;
}

.area-line {
  transition: stroke-width 0.3s ease;
}

.data-point {
  cursor: pointer;
  transition: r 0.2s ease;
}

.data-point:hover {
  r: 6;
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

@media (max-width: 768px) {
  .area-chart {
    min-width: 600px;
  }
  
  .axis-label {
    font-size: 10px;
  }
}
</style>

