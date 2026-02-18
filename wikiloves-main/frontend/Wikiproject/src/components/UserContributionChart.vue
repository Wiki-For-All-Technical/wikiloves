<script setup>
import { computed } from 'vue'

const props = defineProps({
  userData: {
    type: Array,
    required: true,
    default: () => []
  },
  height: {
    type: Number,
    default: 400
  },
  showTop: {
    type: Number,
    default: 20
  }
})

const topUsers = computed(() => {
  return props.userData.slice(0, props.showTop)
})

const maxUploads = computed(() => {
  if (topUsers.value.length === 0) return 1
  return Math.max(...topUsers.value.map(u => u.uploads))
})

const barHeight = computed(() => {
  if (topUsers.value.length === 0) return 0
  return Math.max(20, (props.height - 100) / topUsers.value.length)
})

const barWidth = computed(() => {
  return (value) => {
    return (value / maxUploads.value) * 600
  }
})

const formatPercentage = (value) => {
  return value >= 1 ? value.toFixed(1) : value.toFixed(2)
}
</script>

<template>
  <div class="user-contribution-chart">
    <h3 class="chart-title">Top {{ showTop }} Contributors</h3>
    <div class="chart-container">
      <div class="user-list">
        <div
          v-for="(user, index) in topUsers"
          :key="user.username"
          class="user-row"
        >
          <div class="user-info">
            <span class="user-rank">#{{ index + 1 }}</span>
            <span class="user-name">{{ user.username }}</span>
          </div>
          <div class="bar-container">
            <div
              class="bar"
              :style="{ width: `${barWidth(user.uploads)}px` }"
            >
              <span class="bar-value">{{ user.uploads }}</span>
            </div>
          </div>
          <div class="user-stats">
            <span class="percentage">{{ formatPercentage(user.percentage) }}%</span>
          </div>
        </div>
      </div>
    </div>
    <div class="chart-footer">
      <p>Showing top {{ showTop }} of {{ userData.length }} contributors</p>
    </div>
  </div>
</template>

<style scoped>
.user-contribution-chart {
  width: 100%;
  padding: 1rem 0;
}

.chart-title {
  font-size: 1.25rem;
  font-weight: 600;
  color: #111827;
  margin-bottom: 1.5rem;
}

.chart-container {
  background: #f9fafb;
  border-radius: 8px;
  padding: 1rem;
  max-height: 600px;
  overflow-y: auto;
}

.user-list {
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.user-row {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 0.5rem;
  background: white;
  border-radius: 6px;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.user-row:hover {
  transform: translateX(4px);
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.user-info {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  min-width: 200px;
}

.user-rank {
  font-weight: 600;
  color: #6b7280;
  font-size: 0.875rem;
  min-width: 30px;
}

.user-name {
  font-weight: 500;
  color: #111827;
  font-size: 0.9375rem;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.bar-container {
  flex: 1;
  display: flex;
  align-items: center;
  min-width: 0;
}

.bar {
  height: 28px;
  background: linear-gradient(90deg, #3b82f6 0%, #1e40af 100%);
  border-radius: 4px;
  display: flex;
  align-items: center;
  padding: 0 0.75rem;
  transition: width 0.3s ease;
  min-width: 40px;
}

.bar-value {
  color: white;
  font-weight: 600;
  font-size: 0.8125rem;
  white-space: nowrap;
}

.user-stats {
  min-width: 70px;
  text-align: right;
}

.percentage {
  font-weight: 600;
  color: #059669;
  font-size: 0.875rem;
}

.chart-footer {
  margin-top: 1rem;
  text-align: center;
  color: #6b7280;
  font-size: 0.875rem;
}

@media (max-width: 768px) {
  .user-info {
    min-width: 150px;
  }
  
  .user-name {
    font-size: 0.875rem;
  }
  
  .bar {
    height: 24px;
    padding: 0 0.5rem;
  }
  
  .bar-value {
    font-size: 0.75rem;
  }
}
</style>
