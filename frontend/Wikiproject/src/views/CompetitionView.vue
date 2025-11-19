<script setup>
import { computed, onMounted, watch } from 'vue'
import { RouterLink, useRoute } from 'vue-router'
import { useCatalogStore } from '@/stores/catalog'

const route = useRoute()
const catalog = useCatalogStore()

const currentYear = computed(() => (route.params.year ? Number(route.params.year) : null))
const segment = computed(() => route.params.segment)

const formatNumber = (val) => (val ? val.toLocaleString() : '—')
const formatPercentCell = (value, pct) => `${formatNumber(value)} (${pct ?? 0}%)`

const highlightedYear = (year) => (currentYear.value === year ? 'row--highlight' : '')

const loadCompetition = async () => {
  if (!catalog.navigation.length) {
    await catalog.loadNavigation()
  }
  const slug = catalog.resolveSegment(segment.value) ?? segment.value
  if (slug) {
    await catalog.loadCompetitionDetail(slug)
  }
}

watch(
  () => [route.params.segment, route.params.year],
  () => {
    loadCompetition()
  },
)

onMounted(() => {
  loadCompetition()
})
</script>

<template>
  <section>
    <RouterLink class="back-link" to="/">← Main page</RouterLink>

    <div v-if="catalog.loading.competitionDetail" class="muted">Loading…</div>

    <div v-else-if="catalog.competitionDetail">
      <header class="page-header">
        <h1>{{ catalog.competitionDetail.name }}</h1>
        <p>{{ catalog.competitionDetail.tagline }}</p>
      </header>

      <div class="table-wrapper">
        <table class="comparison-table">
          <thead>
            <tr>
              <th>Year</th>
              <th>Countries</th>
              <th>Uploads</th>
              <th>Images used in the wikis</th>
              <th>Uploaders</th>
              <th>Uploaders registered after competition start</th>
            </tr>
          </thead>
          <tbody>
            <tr
              v-for="year in catalog.competitionDetail.yearly_stats"
              :key="year.year"
              :class="highlightedYear(year.year)"
            >
              <td>{{ year.year }}</td>
              <td>{{ year.countries }}</td>
              <td>{{ formatNumber(year.uploads) }}</td>
              <td>{{ formatPercentCell(year.images_used, year.images_used_pct) }}</td>
              <td>{{ formatNumber(year.uploaders) }}</td>
              <td>{{ formatPercentCell(year.new_uploaders, year.new_uploaders_pct) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>
</template>

<style scoped>
.back-link {
  display: inline-block;
  margin-bottom: 1rem;
}

.row--highlight {
  background: #fff8d6;
}
</style>

