<script setup>
import { ref, computed } from 'vue'

const props = defineProps({
  data: {
    type: Array,
    required: true
  },
  comparisonFields: {
    type: Array,
    default: () => ['uploads', 'images_used', 'uploaders']
  }
})

const selectedItems = ref([])

const toggleSelection = (item) => {
  const index = selectedItems.value.findIndex(i => i.id === item.id)
  if (index > -1) {
    selectedItems.value.splice(index, 1)
  } else if (selectedItems.value.length < 2) {
    selectedItems.value.push(item)
  }
}

const canCompare = computed(() => selectedItems.value.length === 2)

const comparisonData = computed(() => {
  if (!canCompare.value) return null
  
  const [item1, item2] = selectedItems.value
  return {
    item1,
    item2,
    differences: comparisonFields.value.map(field => ({
      field,
      value1: item1[field] || 0,
      value2: item2[field] || 0,
      diff: (item2[field] || 0) - (item1[field] || 0),
      diffPercent: item1[field] 
        ? (((item2[field] || 0) - (item1[field] || 0)) / item1[field]) * 100 
        : 0
    }))
  }
})
</script>

<template>
  <div class="comparison-view">
    <h3>Compare</h3>
    <div class="selection-area">
      <div
        v-for="item in data"
        :key="item.id || item.year || item.name"
        @click="toggleSelection(item)"
        :class="['comparison-item', { selected: selectedItems.includes(item) }]"
      >
        {{ item.name || item.year || item.label }}
      </div>
    </div>
    
    <div v-if="canCompare" class="comparison-results">
      <h4>Comparison Results</h4>
      <table class="comparison-table">
        <thead>
          <tr>
            <th>Metric</th>
            <th>{{ comparisonData.item1.name || comparisonData.item1.year }}</th>
            <th>{{ comparisonData.item2.name || comparisonData.item2.year }}</th>
            <th>Difference</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="diff in comparisonData.differences" :key="diff.field">
            <td>{{ diff.field }}</td>
            <td>{{ diff.value1.toLocaleString() }}</td>
            <td>{{ diff.value2.toLocaleString() }}</td>
            <td :class="{ positive: diff.diff > 0, negative: diff.diff < 0 }">
              {{ diff.diff > 0 ? '+' : '' }}{{ diff.diff.toLocaleString() }}
              ({{ diff.diffPercent > 0 ? '+' : '' }}{{ diff.diffPercent.toFixed(1) }}%)
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>

<style scoped>
.comparison-view {
  padding: 1.5rem;
  background: var(--bg-card, #ffffff);
  border-radius: 12px;
  border: 1px solid var(--border-color, #e5e7eb);
  margin-bottom: 2rem;
}

.selection-area {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
  margin-bottom: 1.5rem;
}

.comparison-item {
  padding: 0.75rem 1.25rem;
  border: 2px solid var(--border-color, #e5e7eb);
  border-radius: 8px;
  background: var(--bg-primary, #ffffff);
  color: var(--text-primary, #111827);
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  user-select: none;
}

.comparison-item:hover {
  border-color: var(--accent-color, #1f8a70);
  background: var(--bg-hover, #f3f4f6);
}

.comparison-item.selected {
  background: var(--accent-color, #1f8a70);
  color: #ffffff;
  border-color: var(--accent-color, #1f8a70);
}

.comparison-results {
  margin-top: 1.5rem;
}

.comparison-results h4 {
  margin: 0 0 1rem 0;
  color: var(--text-primary, #111827);
}

.comparison-table {
  width: 100%;
  border-collapse: collapse;
}

.comparison-table th,
.comparison-table td {
  padding: 0.75rem;
  text-align: left;
  border-bottom: 1px solid var(--border-color, #e5e7eb);
}

.comparison-table th {
  background: var(--bg-secondary, #f9fafb);
  font-weight: 700;
}

.comparison-table td.positive {
  color: #059669;
  font-weight: 600;
}

.comparison-table td.negative {
  color: #dc2626;
  font-weight: 600;
}
</style>

