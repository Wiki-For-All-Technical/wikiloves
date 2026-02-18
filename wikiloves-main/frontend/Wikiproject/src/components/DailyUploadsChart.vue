<script setup>
import { computed } from 'vue'

const props = defineProps({
  dailyData: {
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
    default: 1000
  }
})

const padding = { top: 40, right: 40, bottom: 80, left: 80 }

const maxCount = computed(() => {
  if (props.dailyData.length === 0) return 1
  const max = Math.max(...props.dailyData.map(d => d.count))
  return Math.ceil(max / 10) * 10 || 1
})

const innerWidth = computed(() => props.width - padding.left - padding.right)
const innerHeight = computed(() => props.height - padding.top - padding.bottom)

const xScale = computed(() => {
  if (props.dailyData.length === 0) return () => 0
  if (props.dailyData.length === 1) return () => innerWidth.value / 2
  return (index) => {
    return (index / (props.dailyData.length - 1)) * innerWidth.value
  }
})

const yScale = computed(() => {
  return (value) => {
    return innerHeight.value - ((value / maxCount.value) * innerHeight.value)
  }
})

const barWidth = computed(() => {
  if (props.dailyData.length === 0) return 0
  return Math.max(2, innerWidth.value / props.dailyData.length - 2)
})

const pathData = computed(() => {
  if (props.dailyData.length === 0) return ''
  
  let path = ''
  props.dailyData.forEach((point, index) => {
    const x = padding.left + xScale.value(index)
    const y = padding.top + yScale.value(point.count)
    
    if (index === 0) {
      path = `M ${x} ${y}`
    } else {
      path += ` L ${x} ${y}`
    }
  })
  
  return path
})

const formatDate = (dateStr) => {
  const date = new Date(dateStr)
  return date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' })
}
</script>

<template>
  <div class="daily-uploads-chart">
    <h3 class="chart-title">Daily Uploads</h3>
    <svg
      :width="width"
      :height="height"
      class="chart-svg"
      viewBox="0 0 1000 300"
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
      
      <!-- Line - Main focus like reference design -->
      <path
        :d="pathData"
        class="line"
        stroke="#1f8a70"
        stroke-width="3"
        fill="none"
      />
      
      <!-- Data points -->
      <g class="data-points">
        <circle
          v-for="(point, index) in dailyData"
          :key="`point-${index}`"
          :cx="padding.left + xScale(index)"
          :cy="padding.top + yScale(point.count)"
          r="4"
          fill="#1f8a70"
          stroke="white"
          stroke-width="2"
        >
          <title>{{ formatDate(point.date) }}: {{ point.count }} uploads</title>
        </circle>
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
          v-for="(point, index) in dailyData.filter((_, i) => i % Math.ceil(dailyData.length / 10) === 0 || i === dailyData.length - 1)"
          :key="`x-label-${index}`"
          :x="padding.left + xScale(dailyData.indexOf(point))"
          :y="height - padding.bottom + 20"
          class="axis-label x-label"
          text-anchor="middle"
          transform="rotate(-45, {x}, {y})"
        >
          {{ formatDate(point.date) }}
        </text>
      </g>
    </svg>
  </div>
</template>

<style scoped>
.daily-uploads-chart {
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

.bar {
  transition: opacity 0.2s ease;
  cursor: pointer;
}

.bar:hover {
  opacity: 0.8;
  filter: brightness(1.1);
}

.line {
  pointer-events: none;
}

.data-points circle {
  cursor: pointer;
  transition: r 0.2s ease;
}

.data-points circle:hover {
  r: 5;
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

@media (max-width: 768px) {
  .chart-svg {
    min-width: 800px;
  }
}
</style>
