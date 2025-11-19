<script setup>
import { computed, onMounted } from 'vue'
import { RouterLink } from 'vue-router'
import { useCatalogStore } from '@/stores/catalog'
import CompetitionChart from '@/components/CompetitionChart.vue'

const catalog = useCatalogStore()

onMounted(() => {
  if (!catalog.competitions.length) {
    catalog.bootstrapHome()
  }
})

const navOrder = computed(() =>
  catalog.navigation.filter((entry) => entry.type === 'competition').map((entry) => entry.slug),
)

const competitionSections = computed(() => {
  if (!catalog.competitions.length) return []
  const order = navOrder.value
  const map = new Map(catalog.competitions.map((comp) => [comp.slug, comp]))
  return order.map((slug) => map.get(slug)).filter(Boolean)
})

const formatNumber = (value) => (value ? value.toLocaleString() : '—')
const formatPercentCell = (value, pct) => `${formatNumber(value)} (${pct ?? 0}%)`
</script>

<template>
  <section>
    <header class="page-header">
      <h1>Wiki Loves Competitions Tools</h1>
      <p>Tool Labs – Tools for Wiki Loves Photo Competitions</p>
    </header>

    <article v-for="competition in competitionSections" :key="competition.slug" class="competition-block">
      <h2>{{ competition.name }}</h2>
      <CompetitionChart :years="competition.yearly_stats" />
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
            <tr v-for="year in competition.yearly_stats" :key="year.year">
              <td>
                <RouterLink :to="`/${competition.path_segment}/${year.year}`">{{ year.year }}</RouterLink>
              </td>
              <td>{{ year.countries }}</td>
              <td>{{ formatNumber(year.uploads) }}</td>
              <td>{{ formatPercentCell(year.images_used, year.images_used_pct) }}</td>
              <td>{{ formatNumber(year.uploaders) }}</td>
              <td>{{ formatPercentCell(year.new_uploaders, year.new_uploaders_pct) }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </article>
  </section>
</template>
