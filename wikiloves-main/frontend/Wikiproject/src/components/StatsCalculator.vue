<script setup>
import { computed } from 'vue'

const props = defineProps({
  data: {
    type: Array,
    required: true
  },
  valueField: {
    type: String,
    default: 'uploads'
  }
})

const stats = computed(() => {
  if (!props.data || props.data.length === 0) {
    return {
      total: 0,
      average: 0,
      median: 0,
      min: 0,
      max: 0,
      growth: 0,
      growthPercent: 0
    }
  }
  
  const values = props.data.map(item => item[props.valueField] || 0).filter(v => v > 0)
  
  if (values.length === 0) {
    return {
      total: 0,
      average: 0,
      median: 0,
      min: 0,
      max: 0,
      growth: 0,
      growthPercent: 0
    }
  }
  
  const total = values.reduce((sum, val) => sum + val, 0)
  const average = total / values.length
  const sorted = [...values].sort((a, b) => a - b)
  const median = sorted.length % 2 === 0
    ? (sorted[sorted.length / 2 - 1] + sorted[sorted.length / 2]) / 2
    : sorted[Math.floor(sorted.length / 2)]
  const min = Math.min(...values)
  const max = Math.max(...values)
  
  // Calculate growth (first vs last)
  const first = values[0]
  const last = values[values.length - 1]
  const growth = last - first
  const growthPercent = first > 0 ? ((growth / first) * 100) : 0
  
  return {
    total,
    average,
    median,
    min,
    max,
    growth,
    growthPercent
  }
})

const formatNumber = (num) => {
  return new Intl.NumberFormat('en-US').format(Math.round(num))
}
</script>

<template>
  <div class="stats-calculator">
    <h4>Statistics</h4>
    <div class="stats-grid">
      <div class="stat-item">
        <span class="stat-label">Total</span>
        <span class="stat-value">{{ formatNumber(stats.total) }}</span>
      </div>
      <div class="stat-item">
        <span class="stat-label">Average</span>
        <span class="stat-value">{{ formatNumber(stats.average) }}</span>
      </div>
      <div class="stat-item">
        <span class="stat-label">Median</span>
        <span class="stat-value">{{ formatNumber(stats.median) }}</span>
      </div>
      <div class="stat-item">
        <span class="stat-label">Min</span>
        <span class="stat-value">{{ formatNumber(stats.min) }}</span>
      </div>
      <div class="stat-item">
        <span class="stat-label">Max</span>
        <span class="stat-value">{{ formatNumber(stats.max) }}</span>
      </div>
      <div class="stat-item">
        <span class="stat-label">Growth</span>
        <span class="stat-value" :class="{ positive: stats.growth > 0, negative: stats.growth < 0 }">
          {{ stats.growth > 0 ? '+' : '' }}{{ formatNumber(stats.growth) }}
          ({{ stats.growthPercent > 0 ? '+' : '' }}{{ stats.growthPercent.toFixed(1) }}%)
        </span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.stats-calculator {
  padding: 1.5rem;
  background: var(--bg-card, #ffffff);
  border-radius: 12px;
  border: 1px solid var(--border-color, #e5e7eb);
  margin-bottom: 2rem;
}

.stats-calculator h4 {
  margin: 0 0 1rem 0;
  color: var(--text-primary, #111827);
  font-size: 1.125rem;
  font-weight: 700;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1rem;
}

.stat-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.stat-label {
  font-size: 0.75rem;
  color: var(--text-secondary, #6b7280);
  text-transform: uppercase;
  letter-spacing: 0.5px;
  font-weight: 600;
}

.stat-value {
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--text-primary, #111827);
}

.stat-value.positive {
  color: #10b981;
}

.stat-value.negative {
  color: #ef4444;
}
</style>

