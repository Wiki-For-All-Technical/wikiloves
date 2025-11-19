<script setup>
defineProps({
  label: {
    type: String,
    required: true,
  },
  value: {
    type: [Number, String],
    required: true,
  },
  icon: {
    type: String,
    default: '',
  },
  color: {
    type: String,
    default: '#000',
  },
  delta: {
    type: Number,
    default: null,
  },
  subvalue: {
    type: [Number, String],
    default: null,
  },
  sublabel: {
    type: String,
    default: '',
  },
})

function formatNum(num) {
  if (typeof num === 'string') return num
  return new Intl.NumberFormat('en-US').format(num)
}
</script>

<template>
  <div class="stat-card" :style="{ borderTopColor: color }">
    <div class="stat-header">
      <span class="stat-icon">{{ icon }}</span>
      <span class="stat-label">{{ label }}</span>
    </div>
    <div class="stat-value">{{ formatNum(value) }}</div>
    <div v-if="delta !== null" class="stat-delta" :class="{ positive: delta >= 0, negative: delta < 0 }">
      {{ delta >= 0 ? '+' : '' }}{{ delta.toFixed(1) }}%
    </div>
    <div v-if="subvalue !== null" class="stat-subvalue">
      {{ formatNum(subvalue) }} <span class="stat-sublabel">{{ sublabel }}</span>
    </div>
    <div v-else-if="sublabel" class="stat-sublabel">{{ sublabel }}</div>
  </div>
</template>

<style scoped>
.stat-card {
  background: linear-gradient(135deg, var(--bg-card, #ffffff) 0%, var(--bg-secondary, #f8f9fa) 100%);
  border-radius: 12px;
  border: 1px solid var(--border-color, #e5e7eb);
  border-top-width: 4px;
  padding: 1.75rem;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1), 0 1px 2px rgba(0, 0, 0, 0.06);
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  position: relative;
  overflow: hidden;
}

.stat-card::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: var(--card-accent-color, v-bind(color));
  transform-origin: left;
  transform: scaleX(0);
  transition: transform 0.3s ease;
}

.stat-card:hover {
  transform: translateY(-4px);
  box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15), 0 4px 10px rgba(0, 0, 0, 0.1);
  border-color: rgba(0, 0, 0, 0.1);
}

.stat-card:hover::before {
  transform: scaleX(1);
}

.stat-header {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  margin-bottom: 0.25rem;
}

.stat-icon {
  font-size: 1.75rem;
  line-height: 1;
  filter: drop-shadow(0 1px 2px rgba(0, 0, 0, 0.1));
  transition: transform 0.2s ease;
}

.stat-card:hover .stat-icon {
  transform: scale(1.1);
}

.stat-label {
  font-size: 0.875rem;
  color: var(--text-secondary, #6b7280);
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.stat-value {
  font-size: 2.5rem;
  font-weight: 800;
  color: var(--text-primary, #1f2937);
  line-height: 1;
  background: linear-gradient(135deg, var(--text-primary, #1f2937) 0%, var(--text-secondary, #374151) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  transition: all 0.3s ease;
}

.stat-card:hover .stat-value {
  transform: scale(1.05);
}

.stat-delta {
  font-size: 0.875rem;
  font-weight: 700;
  display: inline-flex;
  align-items: center;
  gap: 0.25rem;
  padding: 0.25rem 0.5rem;
  border-radius: 6px;
  width: fit-content;
  transition: all 0.2s ease;
}

.stat-delta.positive {
  color: #059669;
  background-color: #d1fae5;
}

.stat-delta.negative {
  color: #dc2626;
  background-color: #fee2e2;
}

.stat-delta::before {
  content: '';
  display: inline-block;
  width: 0;
  height: 0;
  margin-right: 0.25rem;
}

.stat-delta.positive::before {
  content: '↑';
  font-size: 0.75rem;
}

.stat-delta.negative::before {
  content: '↓';
  font-size: 0.75rem;
}

.stat-subvalue {
  font-size: 1.125rem;
  color: var(--text-secondary, #4b5563);
  margin-top: 0.5rem;
  font-weight: 600;
}

.stat-sublabel {
  font-size: 0.8125rem;
  color: var(--text-secondary, #9ca3af);
  font-weight: 500;
  margin-top: 0.25rem;
}

@media (max-width: 768px) {
  .stat-card {
    padding: 1.25rem;
  }
  
  .stat-value {
    font-size: 2rem;
  }
}
</style>

