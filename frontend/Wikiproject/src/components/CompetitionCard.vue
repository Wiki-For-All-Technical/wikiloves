<script setup>
import TrendSparkline from './TrendSparkline.vue'

defineProps({
  competition: {
    type: Object,
    required: true,
  },
})
</script>

<template>
  <article class="competition-card" :style="{ borderTopColor: competition.accent_color }">
    <div class="card-header">
      <div>
        <p class="eyebrow">{{ competition.latest_year }}</p>
        <h3>{{ competition.name }}</h3>
        <p class="tagline">{{ competition.tagline }}</p>
      </div>
      <TrendSparkline :values="competition.trend" :color="competition.accent_color" />
    </div>
    <dl class="stat-grid">
      <div>
        <dt>Uploads</dt>
        <dd>{{ competition.latest_uploads.toLocaleString() }}</dd>
      </div>
      <div>
        <dt>Countries</dt>
        <dd>{{ competition.countries }}</dd>
      </div>
      <div>
        <dt>Growth</dt>
        <dd :class="{ positive: competition.uploads_delta >= 0, negative: competition.uploads_delta < 0 }">
          <span>{{ competition.uploads_delta }}%</span>
        </dd>
      </div>
    </dl>
  </article>
</template>

<style scoped>
.competition-card {
  background: var(--bg-card);
  border-radius: 20px;
  border: 1px solid var(--border-soft);
  border-top-width: 3px;
  padding: 1.5rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.card-header {
  display: flex;
  justify-content: space-between;
  gap: 1rem;
  align-items: flex-start;
}

h3 {
  margin: 0.2rem 0;
  font-size: 1.25rem;
  font-weight: 600;
}

.eyebrow {
  text-transform: uppercase;
  letter-spacing: 1px;
  font-size: 0.75rem;
  color: var(--text-muted);
}

.tagline {
  color: var(--text-muted);
  font-size: 0.9rem;
}

.stat-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
  gap: 0.75rem;
}

dt {
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  color: var(--text-muted);
}

dd {
  margin: 0;
  font-size: 1.1rem;
  font-weight: 600;
}

.positive span {
  color: var(--accent-green);
}

.negative span {
  color: var(--accent-red);
}
</style>

