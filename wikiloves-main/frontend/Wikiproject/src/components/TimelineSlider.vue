<script setup>
import { ref, computed, watch, onUnmounted } from 'vue'

const props = defineProps({
  years: {
    type: Array,
    required: true
  },
  currentYear: {
    type: Number,
    default: null
  }
})

const emit = defineEmits(['yearChange', 'play', 'pause'])

const selectedYear = ref(props.currentYear || (props.years.length > 0 ? props.years[props.years.length - 1] : null))
const isPlaying = ref(false)
const playInterval = ref(null)

const sortedYears = computed(() => {
  return [...props.years].sort((a, b) => a - b)
})

const minYear = computed(() => sortedYears.value[0] || 0)
const maxYear = computed(() => sortedYears.value[sortedYears.value.length - 1] || 0)

const handleYearChange = (year) => {
  selectedYear.value = year
  emit('yearChange', year)
}

const togglePlay = () => {
  if (isPlaying.value) {
    pause()
  } else {
    play()
  }
}

const play = () => {
  isPlaying.value = true
  let currentIndex = sortedYears.value.indexOf(selectedYear.value)
  
  playInterval.value = setInterval(() => {
    currentIndex++
    if (currentIndex >= sortedYears.value.length) {
      currentIndex = 0
    }
    handleYearChange(sortedYears.value[currentIndex])
    emit('play')
  }, 1000)
}

const pause = () => {
  isPlaying.value = false
  if (playInterval.value) {
    clearInterval(playInterval.value)
    playInterval.value = null
  }
  emit('pause')
}

watch(() => props.currentYear, (newYear) => {
  if (newYear !== null) {
    selectedYear.value = newYear
  }
})

onUnmounted(() => {
  pause()
})
</script>

<template>
  <div class="timeline-slider">
    <div class="timeline-header">
      <label class="timeline-label">Timeline</label>
      <button
        @click="togglePlay"
        class="play-button"
        :aria-label="isPlaying ? 'Pause' : 'Play'"
      >
        <span v-if="isPlaying">⏸</span>
        <span v-else>▶</span>
      </button>
    </div>
    <div class="slider-container">
      <input
        type="range"
        :min="minYear"
        :max="maxYear"
        :value="selectedYear"
        @input="handleYearChange(parseInt($event.target.value))"
        class="timeline-range"
        :step="1"
      />
      <div class="year-labels">
        <span class="year-label">{{ minYear }}</span>
        <span class="year-label current">{{ selectedYear }}</span>
        <span class="year-label">{{ maxYear }}</span>
      </div>
    </div>
    <div class="year-buttons">
      <button
        v-for="year in sortedYears"
        :key="year"
        @click="handleYearChange(year)"
        :class="['year-button', { active: selectedYear === year }]"
      >
        {{ year }}
      </button>
    </div>
  </div>
</template>

<style scoped>
.timeline-slider {
  padding: 1.5rem;
  background: var(--bg-card, #ffffff);
  border-radius: 12px;
  border: 1px solid var(--border-color, #e5e7eb);
  margin-bottom: 2rem;
}

.timeline-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
}

.timeline-label {
  font-size: 1rem;
  font-weight: 700;
  color: var(--text-primary, #111827);
}

.play-button {
  width: 40px;
  height: 40px;
  border-radius: 50%;
  border: 2px solid var(--accent-color, #1f8a70);
  background: var(--bg-primary, #ffffff);
  color: var(--accent-color, #1f8a70);
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 1.25rem;
  transition: all 0.2s ease;
}

.play-button:hover {
  background: var(--accent-color, #1f8a70);
  color: #ffffff;
  transform: scale(1.1);
}

.slider-container {
  position: relative;
  margin-bottom: 1rem;
}

.timeline-range {
  width: 100%;
  height: 8px;
  border-radius: 4px;
  background: var(--border-color, #e5e7eb);
  outline: none;
  -webkit-appearance: none;
  appearance: none;
}

.timeline-range::-webkit-slider-thumb {
  -webkit-appearance: none;
  appearance: none;
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: var(--accent-color, #1f8a70);
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
  transition: all 0.2s ease;
}

.timeline-range::-webkit-slider-thumb:hover {
  transform: scale(1.2);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
}

.timeline-range::-moz-range-thumb {
  width: 20px;
  height: 20px;
  border-radius: 50%;
  background: var(--accent-color, #1f8a70);
  cursor: pointer;
  border: none;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
}

.year-labels {
  display: flex;
  justify-content: space-between;
  margin-top: 0.5rem;
  font-size: 0.875rem;
  color: var(--text-secondary, #6b7280);
}

.year-label.current {
  font-weight: 700;
  color: var(--accent-color, #1f8a70);
  font-size: 1rem;
}

.year-buttons {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  justify-content: center;
}

.year-button {
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

.year-button:hover {
  border-color: var(--accent-color, #1f8a70);
  background: var(--bg-hover, #f3f4f6);
}

.year-button.active {
  background: var(--accent-color, #1f8a70);
  color: #ffffff;
  border-color: var(--accent-color, #1f8a70);
}
</style>

