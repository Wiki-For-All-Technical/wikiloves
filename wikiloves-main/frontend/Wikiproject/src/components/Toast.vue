<script setup>
import { computed, onMounted, onUnmounted } from 'vue'

const props = defineProps({
  message: {
    type: String,
    required: true
  },
  type: {
    type: String,
    default: 'info',
    validator: (value) => ['success', 'error', 'warning', 'info'].includes(value)
  },
  duration: {
    type: Number,
    default: 3000
  }
})

const emit = defineEmits(['close'])

let timeoutId = null

onMounted(() => {
  if (props.duration > 0) {
    timeoutId = setTimeout(() => {
      emit('close')
    }, props.duration)
  }
})

onUnmounted(() => {
  if (timeoutId) {
    clearTimeout(timeoutId)
  }
})

const icon = computed(() => {
  const icons = {
    success: '✓',
    error: '✕',
    warning: '⚠',
    info: 'ℹ'
  }
  return icons[props.type] || icons.info
})
</script>

<template>
  <div :class="['toast', `toast--${type}`]" role="alert">
    <span class="toast-icon">{{ icon }}</span>
    <span class="toast-message">{{ message }}</span>
    <button @click="emit('close')" class="toast-close" aria-label="Close">×</button>
  </div>
</template>

<style scoped>
.toast {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 1rem 1.25rem;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  background: var(--bg-card, #ffffff);
  border-left: 4px solid;
  min-width: 300px;
  max-width: 500px;
  animation: slideIn 0.3s ease-out;
  position: relative;
  z-index: 10000;
}

.toast--success {
  border-left-color: #10b981;
  background: linear-gradient(135deg, #d1fae5 0%, #ffffff 100%);
}

.toast--error {
  border-left-color: #ef4444;
  background: linear-gradient(135deg, #fee2e2 0%, #ffffff 100%);
}

.toast--warning {
  border-left-color: #f59e0b;
  background: linear-gradient(135deg, #fef3c7 0%, #ffffff 100%);
}

.toast--info {
  border-left-color: #3b82f6;
  background: linear-gradient(135deg, #dbeafe 0%, #ffffff 100%);
}

.toast-icon {
  font-size: 1.25rem;
  font-weight: 700;
  flex-shrink: 0;
}

.toast-message {
  flex: 1;
  font-size: 0.9375rem;
  font-weight: 500;
  color: var(--text-primary, #111827);
}

.toast-close {
  background: transparent;
  border: none;
  font-size: 1.5rem;
  line-height: 1;
  color: var(--text-secondary, #6b7280);
  cursor: pointer;
  padding: 0;
  width: 24px;
  height: 24px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  transition: all 0.2s ease;
  flex-shrink: 0;
}

.toast-close:hover {
  background: rgba(0, 0, 0, 0.1);
  color: var(--text-primary, #111827);
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}

:global(.dark) .toast {
  background: var(--bg-card, #1f2937);
}

:global(.dark) .toast--success {
  background: linear-gradient(135deg, rgba(16, 185, 129, 0.2) 0%, var(--bg-card, #1f2937) 100%);
}

:global(.dark) .toast--error {
  background: linear-gradient(135deg, rgba(239, 68, 68, 0.2) 0%, var(--bg-card, #1f2937) 100%);
}

:global(.dark) .toast--warning {
  background: linear-gradient(135deg, rgba(245, 158, 11, 0.2) 0%, var(--bg-card, #1f2937) 100%);
}

:global(.dark) .toast--info {
  background: linear-gradient(135deg, rgba(59, 130, 246, 0.2) 0%, var(--bg-card, #1f2937) 100%);
}
</style>

