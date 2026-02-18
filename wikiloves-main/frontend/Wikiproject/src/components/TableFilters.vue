<script setup>
import { ref, computed, watch } from 'vue'

const props = defineProps({
  data: {
    type: Array,
    required: true
  },
  searchPlaceholder: {
    type: String,
    default: 'Search...'
  }
})

const emit = defineEmits(['filtered'])

const searchQuery = ref('')
const sortColumn = ref(null)
const sortDirection = ref('asc')

const filteredData = computed(() => {
  let result = [...props.data]
  
  // Apply search filter
  if (searchQuery.value) {
    const query = searchQuery.value.toLowerCase()
    result = result.filter(item => {
      return Object.values(item).some(value => 
        String(value).toLowerCase().includes(query)
      )
    })
  }
  
  // Apply sorting
  if (sortColumn.value) {
    result.sort((a, b) => {
      const aVal = a[sortColumn.value]
      const bVal = b[sortColumn.value]
      const comparison = aVal > bVal ? 1 : aVal < bVal ? -1 : 0
      return sortDirection.value === 'asc' ? comparison : -comparison
    })
  }
  
  return result
})

const handleSort = (column) => {
  if (sortColumn.value === column) {
    sortDirection.value = sortDirection.value === 'asc' ? 'desc' : 'asc'
  } else {
    sortColumn.value = column
    sortDirection.value = 'asc'
  }
}

watch(filteredData, (newData) => {
  emit('filtered', newData)
}, { immediate: true })
</script>

<template>
  <div class="table-filters">
    <div class="search-box">
      <input
        v-model="searchQuery"
        type="text"
        :placeholder="searchPlaceholder"
        class="search-input"
      />
      <span class="search-icon">🔍</span>
    </div>
  </div>
</template>

<style scoped>
.table-filters {
  margin-bottom: 1.5rem;
  display: flex;
  gap: 1rem;
  align-items: center;
}

.search-box {
  position: relative;
  flex: 1;
  max-width: 400px;
}

.search-input {
  width: 100%;
  padding: 0.75rem 1rem 0.75rem 2.5rem;
  border: 2px solid var(--border-color, #e5e7eb);
  border-radius: 8px;
  font-size: 0.9375rem;
  transition: all 0.2s ease;
  background: var(--bg-input, #ffffff);
  color: var(--text-primary, #111827);
}

.search-input:focus {
  outline: none;
  border-color: var(--accent-color, #1f8a70);
  box-shadow: 0 0 0 3px rgba(31, 138, 112, 0.1);
}

.search-icon {
  position: absolute;
  left: 0.75rem;
  top: 50%;
  transform: translateY(-50%);
  pointer-events: none;
  opacity: 0.5;
}

:global(.dark) .search-input {
  --bg-input: #1f2937;
  --border-color: #374151;
  --text-primary: #f9fafb;
}
</style>

