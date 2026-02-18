<script setup>
import { computed } from 'vue'

const props = defineProps({
  stats: {
    type: Object,
    required: true
  }
})

const formatNumber = (num) => {
  if (!num) return '0'
  return new Intl.NumberFormat('en-US').format(num)
}

const formatPercent = (num) => {
  if (!num) return '0%'
  return `${Math.round(num)}%`
}
</script>

<template>
  <div class="quick-stats">
    <div class="stat-item">
      <div class="stat-value">{{ formatNumber(stats.totalUploads) }}</div>
      <div class="stat-label">Total Uploads</div>
    </div>
    <div class="stat-item">
      <div class="stat-value">{{ formatNumber(stats.totalCountries) }}</div>
      <div class="stat-label">Countries</div>
    </div>
    <div class="stat-item">
      <div class="stat-value">{{ formatNumber(stats.totalUploaders) }}</div>
      <div class="stat-label">Uploaders</div>
    </div>
    <div class="stat-item">
      <div class="stat-value">{{ formatPercent(stats.usageRate) }}</div>
      <div class="stat-label">Usage Rate</div>
    </div>
  </div>
</template>

<style scoped>
.quick-stats {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
  padding: 1.5rem;
  background: var(--bg-card, #ffffff);
  border-radius: 12px;
  border: 1px solid var(--border-color, #e5e7eb);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.stat-item {
  text-align: center;
}

.stat-value {
  font-size: 2rem;
  font-weight: 800;
  color: var(--accent-color, #1f8a70);
  line-height: 1;
  margin-bottom: 0.5rem;
}

.stat-label {
  font-size: 0.875rem;
  color: var(--text-secondary, #6b7280);
  font-weight: 500;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

@media (max-width: 768px) {
  .quick-stats {
    grid-template-columns: repeat(2, 1fr);
    gap: 1rem;
    padding: 1rem;
  }
  
  .stat-value {
    font-size: 1.5rem;
  }
}
</style>

