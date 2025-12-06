<script setup>
import { onMounted, watch } from 'vue'
import { RouterLink, useRoute } from 'vue-router'
import { useCatalogStore } from '@/stores/catalog'

const route = useRoute()
const catalog = useCatalogStore()

const loadCountry = () => {
  catalog.loadCountryDetail(route.params.slug)
}

watch(
  () => route.params.slug,
  () => loadCountry(),
)

onMounted(() => {
  loadCountry()
})
</script>

<template>
  <section>
    <RouterLink class="back-link" to="/">← Main page</RouterLink>

    <div v-if="catalog.loading.countryDetail" class="muted">Loading…</div>

    <div v-else-if="catalog.countryDetail">
      <header class="page-header">
        <h1>{{ catalog.countryDetail.name }}</h1>
        <p>
          Region: {{ catalog.countryDetail.region }} · Participating since
          {{ catalog.countryDetail.first_year }}
        </p>
      </header>

      <div class="meta">
        <p><strong>Focus competitions:</strong> {{ catalog.countryDetail.focus.join(', ') }}</p>
        <p><strong>Spotlight:</strong> {{ catalog.countryDetail.spotlight }}</p>
      </div>

      <div class="table-wrapper">
        <table class="comparison-table">
          <thead>
            <tr>
              <th>Year</th>
              <th>Competition</th>
              <th>Uploads</th>
              <th>Rank</th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="entry in catalog.countryDetail.recent_activity" :key="entry.competition + entry.year">
              <td>{{ entry.year }}</td>
              <td>{{ entry.competition }}</td>
              <td>{{ entry.uploads.toLocaleString() }}</td>
              <td>#{{ entry.rank }}</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
  </section>
</template>

<style scoped>
.meta {
  border: 1px solid var(--wiki-border);
  padding: 1rem;
  background: #f7f9fc;
  margin-bottom: 1rem;
}

.back-link {
  display: inline-block;
  margin-bottom: 1rem;
}
</style>
