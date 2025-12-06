import { defineStore } from 'pinia'
import {
  fetchCompetition,
  fetchCompetitions,
  fetchNavigation,
  fetchCountries,
  fetchCountry,
  fetchOverview,
  fetchComparison,
  fetchTrends,
} from '@/services/api'

export const useCatalogStore = defineStore('catalog', {
  state: () => ({
    overview: null,
    navigation: [],
    segmentLookup: {},
    competitions: [],
    competitionDetail: null,
    countries: [],
    countryDetail: null,
    loading: {
      overview: false,
      competitions: false,
      countries: false,
      navigation: false,
      competitionDetail: false,
      countryDetail: false,
    },
    error: null,
  }),
  actions: {
    async bootstrapHome() {
      await Promise.all([
        this.loadNavigation(),
        this.loadOverview(),
        this.loadCompetitions(),
        this.loadCountries(),
      ])
    },
    async loadNavigation() {
      if (this.loading.navigation) return
      this.loading.navigation = true
      this.error = null
      try {
        const nav = await fetchNavigation()
        this.navigation = nav
        this.segmentLookup = nav.reduce((acc, entry) => {
          if (entry.type === 'competition') {
            acc[entry.path_segment] = entry.slug
          }
          return acc
        }, {})
      } catch (error) {
        console.error('Error loading navigation:', error)
        this.error = error.response?.data || error.message || error
      } finally {
        this.loading.navigation = false
      }
    },
    async loadOverview() {
      this.loading.overview = true
      try {
        this.overview = await fetchOverview()
      } catch (error) {
        this.error = error
      } finally {
        this.loading.overview = false
      }
    },
    async loadCompetitions(category = null) {
      this.loading.competitions = true
      try {
        this.competitions = await fetchCompetitions(category)
      } catch (error) {
        this.error = error
      } finally {
        this.loading.competitions = false
      }
    },
    async loadCompetitionDetail(slug) {
      this.loading.competitionDetail = true
      this.competitionDetail = null
      this.error = null
      try {
        this.competitionDetail = await fetchCompetition(slug)
      } catch (error) {
        console.error('Error loading competition detail:', error)
        this.error = error.response?.data || error.message || error
      } finally {
        this.loading.competitionDetail = false
      }
    },
    async loadCountries() {
      this.loading.countries = true
      try {
        this.countries = await fetchCountries()
      } catch (error) {
        this.error = error
      } finally {
        this.loading.countries = false
      }
    },
    async loadCountryDetail(slug) {
      this.loading.countryDetail = true
      this.countryDetail = null
      try {
        this.countryDetail = await fetchCountry(slug)
      } catch (error) {
        this.error = error
      } finally {
        this.loading.countryDetail = false
      }
    },
    resolveSegment(segment) {
      if (!segment) return null
      return this.segmentLookup[segment] ?? null
    },
    async loadComparison(year = null) {
      try {
        return await fetchComparison(year)
      } catch (error) {
        console.error('Error loading comparison:', error)
        this.error = error.response?.data || error.message || error
        throw error
      }
    },
    async loadTrends(campaigns = null) {
      try {
        return await fetchTrends(campaigns)
      } catch (error) {
        console.error('Error loading trends:', error)
        this.error = error.response?.data || error.message || error
        throw error
      }
    },
    async loadCampaignCountryDetail(campaignSlug, year, country) {
      try {
        const response = await fetch(
          `http://127.0.0.1:5000/api/campaigns/${campaignSlug}/${year}/${country}`
        )
        if (!response.ok) {
          throw new Error(`Failed to load country detail: ${response.statusText}`)
        }
        return await response.json()
      } catch (error) {
        console.error('Error loading campaign country detail:', error)
        this.error = error.message || error
        throw error
      }
    },
  },
})

