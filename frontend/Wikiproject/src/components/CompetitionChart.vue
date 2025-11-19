<script setup>
import { computed } from 'vue'

const props = defineProps({
  years: {
    type: Array,
    default: () => [],
  },
})

const chartYears = computed(() => {
  // Show all years, sorted from oldest to newest
  return props.years.slice().reverse()
})
const maxUploads = computed(() => {
  if (!chartYears.value || chartYears.value.length === 0) return 1
  const uploads = chartYears.value.map((entry) => entry.uploads || 0)
  const max = Math.max(...uploads, 1)
  // Round up to nearest nice number for better scaling
  return Math.ceil(max / 10000) * 10000 || 1
})
</script>

<template>
  <div v-if="chartYears.length === 0" class="chart-empty">
    <p>No data available</p>
  </div>
  <div v-else class="chart">
    <div v-for="year in chartYears" :key="year.year" class="chart__group">
      <div
        class="bar bar--uploads"
        :style="{ height: `${Math.max(((year.uploads || 0) / maxUploads) * 100, 2)}%` }"
        :title="`Uploads: ${(year.uploads || 0).toLocaleString()}`"
      ></div>
      <div
        class="bar bar--images"
        :style="{ height: `${Math.max(((year.images_used || 0) / maxUploads) * 100, 2)}%` }"
        :title="`Images Used: ${(year.images_used || 0).toLocaleString()}`"
      ></div>
      <div
        class="bar bar--uploaders"
        :style="{ height: `${Math.max(((year.uploaders || 0) / maxUploads) * 100, 2)}%` }"
        :title="`Uploaders: ${(year.uploaders || 0).toLocaleString()}`"
      ></div>
      <span class="chart__label">{{ year.year }}</span>
    </div>
  </div>
</template>

<style scoped>
.chart {
  display: flex;
  align-items: flex-end;
  gap: 0.5rem;
  padding: 1.5rem 0 3rem 0;
  min-height: 250px;
  height: 250px;
  position: relative;
  width: 100%;
}

.chart::before {
  content: '';
  position: absolute;
  bottom: 30px;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(90deg, transparent 0%, #e5e7eb 20%, #e5e7eb 80%, transparent 100%);
}

.chart__group {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: flex-end;
  gap: 0.15rem;
  flex: 1;
  position: relative;
  transition: transform 0.2s ease;
  height: 100%;
  min-height: 200px;
}

.chart__group:hover {
  transform: translateY(-4px);
}

.chart__group:hover .bar {
  opacity: 0.9;
  filter: brightness(1.1);
}

.bar {
  width: 100%;
  max-width: 28px;
  min-width: 20px;
  border-radius: 4px 4px 0 0;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  position: relative;
  cursor: pointer;
  min-height: 2px;
}

.bar::after {
  content: attr(data-value);
  position: absolute;
  top: -24px;
  left: 50%;
  transform: translateX(-50%);
  font-size: 0.7rem;
  font-weight: 600;
  color: #374151;
  opacity: 0;
  transition: opacity 0.2s ease;
  white-space: nowrap;
  background: rgba(255, 255, 255, 0.95);
  padding: 0.25rem 0.5rem;
  border-radius: 4px;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  pointer-events: none;
}

.bar:hover::after {
  opacity: 1;
}

.bar--uploads {
  background: linear-gradient(180deg, #10b981 0%, #059669 100%);
  z-index: 3;
}

.bar--images {
  background: linear-gradient(180deg, #06b6d4 0%, #0891b2 100%);
  z-index: 2;
}

.bar--uploaders {
  background: linear-gradient(180deg, #3b82f6 0%, #2563eb 100%);
  z-index: 1;
}

.chart__label {
  font-size: 0.75rem;
  color: #6b7280;
  font-weight: 600;
  margin-top: 0.5rem;
  text-align: center;
  min-height: 20px;
  position: absolute;
  bottom: -25px;
  left: 50%;
  transform: translateX(-50%);
  white-space: nowrap;
}

.chart__group:hover .chart__label {
  color: #1f2937;
  font-weight: 700;
}

.chart-empty {
  display: flex;
  align-items: center;
  justify-content: center;
  min-height: 250px;
  color: #9ca3af;
  font-style: italic;
}

@media (max-width: 768px) {
  .chart {
    gap: 0.35rem;
    padding: 1rem 0 3rem 0;
    min-height: 200px;
    height: 200px;
  }
  
  .bar {
    max-width: 18px;
    min-width: 15px;
  }
  
  .chart__label {
    font-size: 0.7rem;
  }
}
</style>







