<script setup>
import { computed } from 'vue'

const props = defineProps({
  years: {
    type: Array,
    default: () => [],
  },
})

const chartYears = computed(() => props.years.slice().reverse().slice(-12))
const maxUploads = computed(() =>
  Math.max(...chartYears.value.map((entry) => entry.uploads), 1),
)
</script>

<template>
  <div class="chart">
    <div v-for="year in chartYears" :key="year.year" class="chart__group">
      <div
        class="bar bar--uploads"
        :style="{ height: `${Math.max((year.uploads / maxUploads) * 100, 5)}%` }"
      ></div>
      <div
        class="bar bar--images"
        :style="{ height: `${Math.max((year.images_used / maxUploads) * 100, 3)}%` }"
      ></div>
      <div
        class="bar bar--uploaders"
        :style="{ height: `${Math.max((year.uploaders / maxUploads) * 100, 3)}%` }"
      ></div>
      <span class="chart__label">{{ year.year }}</span>
    </div>
  </div>
</template>

<style scoped>
.chart {
  display: flex;
  align-items: flex-end;
  gap: 0.4rem;
  padding: 0.75rem 0;
  border-bottom: 1px solid var(--wiki-border);
}

.chart__group {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 0.1rem;
}

.bar {
  width: 12px;
  border-radius: 2px 2px 0 0;
}

.bar--uploads {
  background: #3cb878;
}
.bar--images {
  background: #7bdff2;
}
.bar--uploaders {
  background: #1d4d8b;
}

.chart__label {
  font-size: 0.7rem;
  color: var(--wiki-muted);
}
</style>






