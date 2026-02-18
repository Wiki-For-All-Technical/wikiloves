<script setup>
import { computed } from 'vue'
import { formatFileSize } from '../utils/quarryDataProcessor.js'

const props = defineProps({
  sizeData: {
    type: Array,
    required: true,
    default: () => []
  },
  height: {
    type: Number,
    default: 300
  },
  width: {
    type: Number,
    default: 800
  }
})

const padding = { top: 40, right: 40, bottom: 80, left: 60 }

const maxCount = computed(() => {
  if (props.sizeData.length === 0) return 1
  return Math.max(...props.sizeData.map(d => d.count))
})

const innerWidth = computed(() => props.width - padding.left - padding.right)
const innerHeight = computed(() => props.height - padding.top - padding.bottom)

const barWidth = computed(() => {
  if (props.sizeData.length === 0) return 0
  return innerWidth.value / props.sizeData.length - 10
})

const yScale = computed(() => {
  return (value) => {
    return innerHeight.value - ((value / maxCount.value) * innerHeight.value)
  }
})

const colors = [
  '#3b82f6', // Blue
  '#10b981', // Green
  '#f59e0b', // Amber
  '#ef4444', // Red
  '#8b5cf6', // Purple
  '#ec4899'  // Pink
]

const getColor = (index) => {
  return colors[index % colors.length]
}
</script>

<template>
  <div class="file-size-spectrum-chart">
    <h3 class="chart-title">File Size Distribution</h3>
    <svg
      :width="width"
      :height="height"
      class="chart-svg"
      viewBox="0 0 800 300"
      preserveAspectRatio="xMidYMid meet"
    >
      <!-- Grid lines -->
      <g class="grid-lines">
        <line
          v-for="(value, index) in Array.from({ length: 6 }, (_, i) => (i * maxCount) / 5)"
          :key="`grid-${index}`"
          :x1="padding.left"
          :y1="padding.top + yScale(value)"
          :x2="width - padding.right"
          :y2="padding.top + yScale(value)"
          class="grid-line"
        />
      </g>
      
      <!-- Bars -->
      <g class="bars">
        <rect
          v-for="(bucket, index) in sizeData"
          :key="`bar-${index}`"
          :x="padding.left + index * (innerWidth / sizeData.length) + 5"
          :y="padding.top + yScale(bucket.count)"
          :width="barWidth"
          :height="innerHeight - yScale(bucket.count)"
          :fill="getColor(index)"
          class="bar"
        >
          <title>{{ bucket.label }}: {{ bucket.count }} files</title>
        </rect>
      </g>
      
      <!-- Y-axis labels -->
      <g class="y-axis">
        <text
          v-for="(value, index) in Array.from({ length: 6 }, (_, i) => (i * maxCount) / 5)"
          :key="`y-label-${index}`"
          :x="padding.left - 10"
          :y="padding.top + yScale(value) + 4"
          class="axis-label y-label"
          text-anchor="end"
        >
          {{ Math.round(value) }}
        </text>
      </g>
      
      <!-- X-axis labels -->
      <g class="x-axis">
        <text
          v-for="(bucket, index) in sizeData"
          :key="`x-label-${index}`"
          :x="padding.left + index * (innerWidth / sizeData.length) + innerWidth / (sizeData.length * 2)"
          :y="height - padding.bottom + 20"
          class="axis-label x-label"
          text-anchor="middle"
        >
          {{ bucket.label }}
        </text>
      </g>
    </svg>
    
    <!-- Legend -->
    <div class="chart-legend">
      <div
        v-for="(bucket, index) in sizeData"
        :key="bucket.label"
        class="legend-item"
      >
        <span
          class="legend-color"
          :style="{ backgroundColor: getColor(index) }"
        ></span>
        <span class="legend-label">{{ bucket.label }}</span>
        <span class="legend-count">({{ bucket.count }} files)</span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.file-size-spectrum-chart {
  width: 100%;
  overflow-x: auto;
  padding: 1rem 0;
}

.chart-title {
  font-size: 1.25rem;
  font-weight: 600;
  color: #111827;
  margin-bottom: 1rem;
}

.chart-svg {
  display: block;
  width: 100%;
  height: auto;
  min-width: 800px;
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
  transition: opacity 0.2s ease, filter 0.2s ease;
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
  font-size: 10px;
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
  width: 16px;
  height: 16px;
  border-radius: 3px;
  display: inline-block;
}

.legend-label {
  color: #374151;
  font-weight: 500;
}

.legend-count {
  color: #6b7280;
  font-size: 0.75rem;
}

@media (max-width: 768px) {
  .chart-svg {
    min-width: 600px;
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
