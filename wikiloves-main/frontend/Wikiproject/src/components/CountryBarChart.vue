<script setup>
import { computed } from 'vue'

const props = defineProps({
  countryName: {
    type: String,
    required: true
  },
  yearData: {
    type: Array,
    required: true,
    default: () => []
  },
  height: {
    type: Number,
    default: 250
  },
  padding: {
    type: Object,
    default: () => ({ top: 20, right: 40, bottom: 60, left: 60 })
  }
})

// Sort years from oldest to newest
const sortedData = computed(() => {
  return [...props.yearData].sort((a, b) => a.year - b.year)
})

const chartWidth = computed(() => Math.max(600, sortedData.value.length * 120))
const chartHeight = computed(() => props.height)

const innerWidth = computed(() => {
  return chartWidth.value - props.padding.left - props.padding.right
})

const innerHeight = computed(() => {
  return chartHeight.value - props.padding.top - props.padding.bottom
})

const maxValue = computed(() => {
  if (sortedData.value.length === 0) return 1
  const maxUploads = Math.max(...sortedData.value.map(d => d.uploads || 0))
  const maxImagesUsed = Math.max(...sortedData.value.map(d => d.images_used || 0))
  const maxUploaders = Math.max(...sortedData.value.map(d => d.uploaders || 0))
  const maxNewUploaders = Math.max(...sortedData.value.map(d => d.new_uploaders || 0))
  const max = Math.max(maxUploads, maxImagesUsed, maxUploaders, maxNewUploaders)
  return Math.ceil(max / 100) * 100 || 1
})

const barWidth = computed(() => {
  if (sortedData.value.length === 0) return 0
  const availableWidth = innerWidth.value / sortedData.value.length
  return Math.min(15, (availableWidth - 20) / 4) // 4 bars with spacing
})

const groupWidth = computed(() => {
  return barWidth.value * 4 + 20 // 4 bars + spacing between groups
})

const xScale = computed(() => {
  if (sortedData.value.length === 0) return () => 0
  if (sortedData.value.length === 1) return () => innerWidth.value / 2
  return (index) => {
    const step = innerWidth.value / sortedData.value.length
    return step * index + step / 2
  }
})

const yScale = computed(() => {
  return (value) => {
    return innerHeight.value - ((value / maxValue.value) * innerHeight.value)
  }
})

const getBarX = (yearIndex, barIndex) => {
  const centerX = props.padding.left + xScale.value(yearIndex)
  const offset = (barIndex - 1.5) * (barWidth.value + 2) // 2px spacing between bars
  return centerX + offset
}

const getBarHeight = (value) => {
  return (value / maxValue.value) * innerHeight.value
}

// Colors matching the reference website
const colors = {
  uploads: '#166534', // Dark green
  imagesUsed: '#86efac', // Light green
  uploaders: '#3b82f6', // Medium blue
  newUploaders: '#1e3a8a' // Dark blue
}

const formatNum = (num) => {
  return new Intl.NumberFormat('en-US').format(num)
}
</script>

<template>
  <div class="country-bar-chart-container">
    <svg
      :width="chartWidth"
      :height="chartHeight"
      class="country-bar-chart"
      :viewBox="`0 0 ${chartWidth} ${chartHeight}`"
      preserveAspectRatio="xMidYMid meet"
    >
      <!-- Grid lines -->
      <g class="grid-lines">
        <line
          v-for="i in 6"
          :key="`grid-${i}`"
          :x1="padding.left"
          :y1="padding.top + (innerHeight / 5) * (i - 1)"
          :x2="chartWidth - padding.right"
          :y2="padding.top + (innerHeight / 5) * (i - 1)"
          class="grid-line"
        />
      </g>
      
      <!-- Bars for each year -->
      <g class="bars">
        <template v-for="(entry, yearIndex) in sortedData" :key="entry.year">
          <!-- Uploads bar (dark green) -->
          <rect
            :x="getBarX(yearIndex, 0)"
            :y="padding.top + innerHeight - getBarHeight(entry.uploads || 0)"
            :width="barWidth"
            :height="getBarHeight(entry.uploads || 0)"
            :fill="colors.uploads"
            class="bar"
            :data-year="entry.year"
            :data-type="'uploads'"
          >
            <title>Uploads: {{ formatNum(entry.uploads || 0) }}</title>
          </rect>
          
          <!-- Images used bar (light green) -->
          <rect
            :x="getBarX(yearIndex, 1)"
            :y="padding.top + innerHeight - getBarHeight(entry.images_used || 0)"
            :width="barWidth"
            :height="getBarHeight(entry.images_used || 0)"
            :fill="colors.imagesUsed"
            class="bar"
            :data-year="entry.year"
            :data-type="'images-used'"
          >
            <title>Images used: {{ formatNum(entry.images_used || 0) }} ({{ Math.round((entry.images_used / entry.uploads * 100) || 0) }}%)</title>
          </rect>
          
          <!-- Uploaders bar (medium blue) -->
          <rect
            :x="getBarX(yearIndex, 2)"
            :y="padding.top + innerHeight - getBarHeight(entry.uploaders || 0)"
            :width="barWidth"
            :height="getBarHeight(entry.uploaders || 0)"
            :fill="colors.uploaders"
            class="bar"
            :data-year="entry.year"
            :data-type="'uploaders'"
          >
            <title>Uploaders: {{ formatNum(entry.uploaders || 0) }}</title>
          </rect>
          
          <!-- New uploaders bar (dark blue) -->
          <rect
            :x="getBarX(yearIndex, 3)"
            :y="padding.top + innerHeight - getBarHeight(entry.new_uploaders || 0)"
            :width="barWidth"
            :height="getBarHeight(entry.new_uploaders || 0)"
            :fill="colors.newUploaders"
            class="bar"
            :data-year="entry.year"
            :data-type="'new-uploaders'"
          >
            <title>New uploaders: {{ formatNum(entry.new_uploaders || 0) }} ({{ Math.round((entry.new_uploaders / entry.uploaders * 100) || 0) }}%)</title>
          </rect>
        </template>
      </g>
      
      <!-- Y-axis labels -->
      <g class="y-axis">
        <text
          v-for="i in 6"
          :key="`y-label-${i}`"
          :x="padding.left - 10"
          :y="padding.top + (innerHeight / 5) * (i - 1) + 4"
          class="axis-label y-label"
          text-anchor="end"
        >
          {{ Math.round((maxValue / 5) * (6 - i)) }}
        </text>
      </g>
      
      <!-- X-axis labels (years) -->
      <g class="x-axis">
        <text
          v-for="(entry, yearIndex) in sortedData"
          :key="`x-label-${entry.year}`"
          :x="padding.left + xScale(yearIndex)"
          :y="chartHeight - padding.bottom + 20"
          class="axis-label x-label"
          text-anchor="middle"
        >
          {{ entry.year }}
        </text>
      </g>
    </svg>
    
    <!-- Legend -->
    <div class="chart-legend">
      <div class="legend-item">
        <span class="legend-color" :style="{ backgroundColor: colors.uploads }"></span>
        <span class="legend-label">Uploads</span>
      </div>
      <div class="legend-item">
        <span class="legend-color" :style="{ backgroundColor: colors.imagesUsed }"></span>
        <span class="legend-label">Images used in the wikis</span>
      </div>
      <div class="legend-item">
        <span class="legend-color" :style="{ backgroundColor: colors.uploaders }"></span>
        <span class="legend-label">Uploaders</span>
      </div>
      <div class="legend-item">
        <span class="legend-color" :style="{ backgroundColor: colors.newUploaders }"></span>
        <span class="legend-label">Uploaders registered after competition start</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.country-bar-chart-container {
  width: 100%;
  overflow-x: auto;
  padding: 1rem 0;
}

.country-bar-chart {
  display: block;
  width: 100%;
  height: auto;
  min-width: 600px;
}

.grid-lines {
  opacity: 0.2;
}

.grid-line {
  stroke: #9ca3af;
  stroke-width: 1;
  stroke-dasharray: 2, 2;
}

.bar {
  transition: opacity 0.2s ease;
  cursor: pointer;
}

.bar:hover {
  opacity: 0.8;
  filter: brightness(1.1);
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
  gap: 1.5rem;
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
  width: 16px;
  height: 16px;
  border-radius: 2px;
  display: inline-block;
}

.legend-label {
  color: #374151;
  font-weight: 500;
}

@media (max-width: 768px) {
  .country-bar-chart {
    min-width: 500px;
  }
  
  .axis-label {
    font-size: 10px;
  }
  
  .chart-legend {
    font-size: 0.75rem;
    gap: 1rem;
  }
}
</style>

