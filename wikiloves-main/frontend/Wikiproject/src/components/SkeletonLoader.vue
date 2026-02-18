<script setup>
defineProps({
  type: {
    type: String,
    default: 'text',
    validator: (value) => ['text', 'card', 'table', 'chart', 'circle'].includes(value)
  },
  lines: {
    type: Number,
    default: 3
  },
  width: {
    type: String,
    default: '100%'
  },
  height: {
    type: String,
    default: '1rem'
  }
})
</script>

<template>
  <div v-if="type === 'text'" class="skeleton skeleton-text" :style="{ width, height }"></div>
  <div v-else-if="type === 'card'" class="skeleton skeleton-card" :style="{ width, height }"></div>
  <div v-else-if="type === 'table'" class="skeleton-table">
    <div v-for="i in lines" :key="i" class="skeleton skeleton-row"></div>
  </div>
  <div v-else-if="type === 'chart'" class="skeleton skeleton-chart" :style="{ width, height }"></div>
  <div v-else-if="type === 'circle'" class="skeleton skeleton-circle" :style="{ width, height }"></div>
</template>

<style scoped>
.skeleton {
  background: linear-gradient(
    90deg,
    var(--skeleton-base, #f0f0f0) 25%,
    var(--skeleton-highlight, #e0e0e0) 50%,
    var(--skeleton-base, #f0f0f0) 75%
  );
  background-size: 200% 100%;
  animation: skeleton-loading 1.5s ease-in-out infinite;
  border-radius: 4px;
}

.skeleton-text {
  height: 1rem;
  margin-bottom: 0.5rem;
}

.skeleton-card {
  border-radius: 8px;
  min-height: 200px;
}

.skeleton-chart {
  border-radius: 8px;
  min-height: 300px;
}

.skeleton-circle {
  border-radius: 50%;
  aspect-ratio: 1;
}

.skeleton-table {
  display: flex;
  flex-direction: column;
  gap: 0.5rem;
}

.skeleton-row {
  height: 3rem;
  width: 100%;
}

@keyframes skeleton-loading {
  0% {
    background-position: 200% 0;
  }
  100% {
    background-position: -200% 0;
  }
}

:global(.dark) .skeleton {
  --skeleton-base: #2a2a2a;
  --skeleton-highlight: #3a3a3a;
}
</style>

