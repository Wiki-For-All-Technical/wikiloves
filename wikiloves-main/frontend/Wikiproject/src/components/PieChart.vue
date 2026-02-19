<script setup>
import { computed } from 'vue'

const props = defineProps({
  segments: {
    type: Array,
    required: true,
    default: () => []
  },
  size: { type: Number, default: 180 },
  strokeWidth: { type: Number, default: 24 },
  title: { type: String, default: '' }
})

const total = computed(() => {
  const sum = props.segments.reduce((s, seg) => s + (seg.value || 0), 0)
  return sum || 1
})

const radius = computed(() => (props.size - props.strokeWidth) / 2)

function getSegmentPath(startFraction, endFraction) {
  const r = radius.value
  const startAngle = 2 * Math.PI * startFraction - Math.PI / 2
  const endAngle = 2 * Math.PI * endFraction - Math.PI / 2
  const x1 = r * Math.cos(startAngle)
  const y1 = r * Math.sin(startAngle)
  const x2 = r * Math.cos(endAngle)
  const y2 = r * Math.sin(endAngle)
  const large = endFraction - startFraction > 0.5 ? 1 : 0
  return `M 0 0 L ${x1} ${y1} A ${r} ${r} 0 ${large} 1 ${x2} ${y2} Z`
}
</script>

<template>
  <div class="pie-chart">
    <h3 v-if="title" class="pie-chart-title">{{ title }}</h3>
    <svg :width="size" :height="size" class="pie-svg" :viewBox="`0 0 ${size} ${size}`" aria-hidden="true">
      <g :transform="`translate(${size/2}, ${size/2})`">
        <path
          v-for="(seg, i) in segments"
          :key="i"
          :d="getSegmentPath(
            segments.slice(0, i).reduce((s, x) => s + (x.value || 0) / total, 0),
            segments.slice(0, i + 1).reduce((s, x) => s + (x.value || 0) / total, 0)
          )"
          :fill="seg.color || '#94a3b8'"
          stroke="#fff"
          stroke-width="2"
        />
      </g>
    </svg>
    <ul class="pie-legend">
      <li v-for="(seg, i) in segments" :key="i" class="pie-legend-item">
        <span class="pie-legend-dot" :style="{ backgroundColor: seg.color || '#94a3b8' }" />
        <span class="pie-legend-label">{{ seg.label }}</span>
        <span class="pie-legend-pct">{{ total > 0 ? Math.round((seg.value / total) * 100) : 0 }}%</span>
      </li>
    </ul>
  </div>
</template>

<style scoped>
.pie-chart {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 1rem;
}

.pie-chart-title {
  font-size: 1rem;
  font-weight: 600;
  color: var(--text-primary, #111827);
  margin: 0 0 0.75rem;
}

.pie-svg {
  display: block;
}

.pie-legend {
  list-style: none;
  margin: 0.75rem 0 0;
  padding: 0;
  font-size: 0.875rem;
}

.pie-legend-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-top: 0.35rem;
}

.pie-legend-dot {
  width: 10px;
  height: 10px;
  border-radius: 50%;
  flex-shrink: 0;
}

.pie-legend-label {
  color: var(--text-secondary, #6b7280);
}

.pie-legend-pct {
  font-weight: 600;
  color: var(--text-primary, #111827);
  margin-left: auto;
}
</style>
