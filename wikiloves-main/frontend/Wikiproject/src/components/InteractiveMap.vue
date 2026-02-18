<script setup>
import { computed, ref } from 'vue'

const props = defineProps({
  countryData: {
    type: Array,
    required: true
  },
  onCountryClick: {
    type: Function,
    default: null
  }
})

const selectedCountry = ref(null)

const countryMap = computed(() => {
  const map = new Map()
  props.countryData.forEach(country => {
    map.set(country.name.toLowerCase(), country)
  })
  return map
})

const getCountryValue = (countryName) => {
  const country = countryMap.value.get(countryName.toLowerCase())
  return country ? (country.uploads || country.value || 0) : 0
}

const maxValue = computed(() => {
  const values = props.countryData.map(c => c.uploads || c.value || 0)
  return Math.max(...values, 1)
})

const getCountryColor = (countryName) => {
  const value = getCountryValue(countryName)
  if (value === 0) return '#e5e7eb'
  
  const intensity = Math.min(value / maxValue.value, 1)
  const hue = 120 - (intensity * 60) // Green to yellow
  return `hsl(${hue}, 70%, 50%)`
}

const handleCountryClick = (countryName) => {
  selectedCountry.value = countryName
  if (props.onCountryClick) {
    props.onCountryClick(countryName)
  }
}
</script>

<template>
  <div class="interactive-map-container">
    <div class="map-wrapper">
      <!-- Simplified world map using SVG paths -->
      <svg
        viewBox="0 0 1000 500"
        class="world-map"
        preserveAspectRatio="xMidYMid meet"
      >
        <!-- This is a placeholder - in production, you'd use actual country SVG paths -->
        <text x="500" y="250" text-anchor="middle" class="map-placeholder">
          Interactive Map
        </text>
        <text x="500" y="280" text-anchor="middle" class="map-subtitle">
          (Country paths would be rendered here)
        </text>
      </svg>
    </div>
    <div class="map-legend">
      <div class="legend-title">Uploads</div>
      <div class="legend-scale">
        <div class="legend-item">
          <div class="legend-color" style="background: #e5e7eb;"></div>
          <span>0</span>
        </div>
        <div class="legend-item">
          <div class="legend-color" style="background: hsl(90, 70%, 50%);"></div>
          <span>Low</span>
        </div>
        <div class="legend-item">
          <div class="legend-color" style="background: hsl(60, 70%, 50%);"></div>
          <span>Medium</span>
        </div>
        <div class="legend-item">
          <div class="legend-color" style="background: hsl(30, 70%, 50%);"></div>
          <span>High</span>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.interactive-map-container {
  width: 100%;
  padding: 1.5rem;
  background: var(--bg-card, #ffffff);
  border-radius: 12px;
  border: 1px solid var(--border-color, #e5e7eb);
}

.map-wrapper {
  width: 100%;
  overflow: hidden;
  border-radius: 8px;
  background: var(--bg-secondary, #f9fafb);
  margin-bottom: 1rem;
}

.world-map {
  width: 100%;
  height: auto;
  min-height: 400px;
}

.map-placeholder {
  font-size: 2rem;
  font-weight: 700;
  fill: var(--text-secondary, #6b7280);
}

.map-subtitle {
  font-size: 1rem;
  fill: var(--text-secondary, #6b7280);
}

.map-legend {
  padding: 1rem;
  background: var(--bg-secondary, #f9fafb);
  border-radius: 8px;
}

.legend-title {
  font-weight: 700;
  margin-bottom: 0.75rem;
  color: var(--text-primary, #111827);
}

.legend-scale {
  display: flex;
  align-items: center;
  gap: 1rem;
  flex-wrap: wrap;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  font-size: 0.875rem;
  color: var(--text-secondary, #6b7280);
}

.legend-color {
  width: 24px;
  height: 16px;
  border-radius: 4px;
  border: 1px solid var(--border-color, #e5e7eb);
}
</style>

