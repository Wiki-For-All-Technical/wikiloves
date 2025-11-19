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
  background: #fff;
  border-radius: 8px;
  border: 1px solid #e0e0e0;
  border-top-width: 3px;
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
}

.stat-header {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  margin-bottom: 0.5rem;
}

.stat-icon {
  font-size: 1.5rem;
}

.stat-label {
  font-size: 0.9rem;
  color: #666;
  font-weight: 500;
}

.stat-value {
  font-size: 2rem;
  font-weight: 700;
  color: #2c3e50;
  line-height: 1;
}

.stat-delta {
  font-size: 0.85rem;
  font-weight: 600;
}

.stat-delta.positive {
  color: #22c55e;
}

.stat-delta.negative {
  color: #ef4444;
}

.stat-subvalue {
  font-size: 1.1rem;
  color: #666;
  margin-top: 0.25rem;
}

.stat-sublabel {
  font-size: 0.85rem;
  color: #999;
  font-weight: 400;
}
</style>

