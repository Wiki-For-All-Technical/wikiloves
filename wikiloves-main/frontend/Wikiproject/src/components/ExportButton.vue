<script setup>
import { ref } from 'vue'
import { useToast } from '@/composables/useToast'

const props = defineProps({
  data: {
    type: Array,
    required: true
  },
  filename: {
    type: String,
    default: 'export'
  },
  type: {
    type: String,
    default: 'csv',
    validator: (value) => ['csv', 'json'].includes(value)
  }
})

const isExporting = ref(false)
const toast = useToast()

const exportData = () => {
  isExporting.value = true
  
  try {
    if (props.type === 'csv') {
      exportToCSV()
    } else {
      exportToJSON()
    }
    toast.success(`Data exported as ${props.type.toUpperCase()}!`)
  } catch (error) {
    console.error('Export failed:', error)
    toast.error('Export failed. Please try again.')
  } finally {
    setTimeout(() => {
      isExporting.value = false
    }, 500)
  }
}

const exportToCSV = () => {
  if (props.data.length === 0) {
    toast.warning('No data to export')
    return
  }
  
  const headers = Object.keys(props.data[0])
  const csvContent = [
    headers.join(','),
    ...props.data.map(row => 
      headers.map(header => {
        const value = row[header]
        // Escape commas and quotes
        if (value === null || value === undefined) return ''
        const stringValue = String(value).replace(/"/g, '""')
        return `"${stringValue}"`
      }).join(',')
    )
  ].join('\n')
  
  const blob = new Blob([csvContent], { type: 'text/csv;charset=utf-8;' })
  const link = document.createElement('a')
  const url = URL.createObjectURL(blob)
  link.setAttribute('href', url)
  link.setAttribute('download', `${props.filename}.csv`)
  link.style.visibility = 'hidden'
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}

const exportToJSON = () => {
  const jsonContent = JSON.stringify(props.data, null, 2)
  const blob = new Blob([jsonContent], { type: 'application/json' })
  const link = document.createElement('a')
  const url = URL.createObjectURL(blob)
  link.setAttribute('href', url)
  link.setAttribute('download', `${props.filename}.json`)
  link.style.visibility = 'hidden'
  document.body.appendChild(link)
  link.click()
  document.body.removeChild(link)
}
</script>

<template>
  <button
    @click="exportData"
    class="export-button"
    :disabled="isExporting || data.length === 0"
    :title="`Export as ${type.toUpperCase()}`"
  >
    <span v-if="isExporting" class="export-icon">⏳</span>
    <span v-else class="export-icon">📥</span>
    <span class="export-text">{{ isExporting ? 'Exporting...' : `Export ${type.toUpperCase()}` }}</span>
  </button>
</template>

<style scoped>
.export-button {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.625rem 1rem;
  background: var(--accent-color, #1f8a70);
  color: #ffffff;
  border: none;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.export-button:hover:not(:disabled) {
  background: var(--accent-hover, #1a6b57);
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

.export-button:active:not(:disabled) {
  transform: translateY(0);
}

.export-button:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}

.export-icon {
  font-size: 1rem;
  line-height: 1;
}

.export-text {
  font-weight: 600;
}
</style>

