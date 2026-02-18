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
        // Fetch from Toolforge API
        const response = await fetch(
          `https://wikiloves-data.toolforge.org/api/data/${campaignSlug}`
        )
        if (!response.ok) {
          throw new Error(`Failed to load campaign data: ${response.statusText}`)
        }
        const data = await response.json()
        
        // Find the year and country in the Toolforge data structure
        const yearData = data.years?.find(y => y.year === year)
        if (!yearData) {
          throw new Error(`No data found for year ${year}`)
        }
        
        // Find country data
        const countryData = yearData.countries?.find(c => 
          c.country.toLowerCase().replace(/\s+/g, '_') === country.toLowerCase().replace(/\s+/g, '_') ||
          c.country.toLowerCase() === country.toLowerCase()
        )
        
        if (!countryData) {
          throw new Error(`No data found for country ${country}`)
        }
        
        // Transform Toolforge data structure to match expected format
        return {
          campaign: data.campaign_name || campaignSlug,
          year: year,
          country: countryData.country,
          category_name: `Images_from_${data.campaign_name?.replace(/\s+/g, '_')}_${year}_in_${countryData.country.replace(/\s+/g, '_')}`,
          total_uploads: countryData.uploads || 0,
          total_uploaders: countryData.uploaders || 0,
          total_images_used: countryData.images_used || 0,
          total_new_uploaders: countryData.new_uploaders || 0,
          daily_stats: countryData.daily_stats || []
        }
      } catch (error) {
        console.error('Error loading campaign country detail:', error)
        this.error = error.message || error
        throw error
      }
    },
  },
})

