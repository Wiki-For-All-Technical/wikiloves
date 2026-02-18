<script setup>
import { ref } from 'vue'

const props = defineProps({
  chartTypes: {
    type: Array,
    default: () => ['line', 'bar', 'area']
  }
})

const emit = defineEmits(['chartTypeChange', 'reset', 'export'])

const selectedType = ref('line')

const handleTypeChange = (type) => {
  selectedType.value = type
  emit('chartTypeChange', type)
}

const handleReset = () => {
  emit('reset')
}

const handleExport = () => {
  emit('export')
}
</script>

<template>
  <div class="chart-controls">
    <div class="control-group">
      <label class="control-label">Chart Type:</label>
      <div class="button-group">
        <button
          v-for="type in chartTypes"
          :key="type"
          @click="handleTypeChange(type)"
          :class="['control-button', { active: selectedType === type }]"
        >
          {{ type.charAt(0).toUpperCase() + type.slice(1) }}
        </button>
      </div>
    </div>
    <div class="control-group">
      <button @click="handleReset" class="control-button secondary">
        Reset View
      </button>
      <button @click="handleExport" class="control-button secondary">
        Export Image
      </button>
    </div>
  </div>
</template>

<style scoped>
.chart-controls {
  display: flex;
  justify-content: space-between;
  align-items: center;
  flex-wrap: wrap;
  gap: 1rem;
  padding: 1rem;
  background: var(--bg-card, #ffffff);
  border-radius: 8px;
  border: 1px solid var(--border-color, #e5e7eb);
  margin-bottom: 1rem;
}

.control-group {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.control-label {
  font-size: 0.875rem;
  font-weight: 600;
  color: var(--text-secondary, #6b7280);
}

.button-group {
  display: flex;
  gap: 0.5rem;
}

.control-button {
  padding: 0.5rem 1rem;
  border: 2px solid var(--border-color, #e5e7eb);
  border-radius: 6px;
  background: var(--bg-primary, #ffffff);
  color: var(--text-primary, #111827);
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.control-button:hover {
  border-color: var(--accent-color, #1f8a70);
  background: var(--bg-hover, #f3f4f6);
}

.control-button.active {
  background: var(--accent-color, #1f8a70);
  color: #ffffff;
  border-color: var(--accent-color, #1f8a70);
}

.control-button.secondary {
  background: transparent;
}

@media (max-width: 768px) {
  .chart-controls {
    flex-direction: column;
    align-items: stretch;
  }
  
  .control-group {
    flex-direction: column;
    align-items: stretch;
  }
  
  .button-group {
    flex-direction: column;
  }
}
</style>

