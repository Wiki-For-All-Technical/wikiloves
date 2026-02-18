<script setup>
import { computed } from 'vue'
import { buildTrendPoints } from '@/utils/trend'

const props = defineProps({
  values: {
    type: Array,
    default: () => [],
  },
  color: {
    type: String,
    default: 'var(--accent-green)',
  },
})

const points = computed(() => buildTrendPoints(props.values))
</script>

<template>
  <svg v-if="points" viewBox="0 0 120 40" preserveAspectRatio="none" class="sparkline">
    <polyline :points="points" :stroke="color" stroke-width="2.5" fill="none" stroke-linecap="round" />
  </svg>
  <div v-else class="sparkline sparkline--empty">–</div>
</template>

<style scoped>
.sparkline {
  width: 120px;
  height: 40px;
}

.sparkline--empty {
  display: grid;
  place-items: center;
  color: var(--text-muted);
  border: 1px dashed var(--border-soft);
  border-radius: 12px;
}
</style>

