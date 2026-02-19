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
  fetchToolforgeCountryDetail,
  fetchToolforgeCampaignData,
  fetchToolforgeCampaigns,
} from '@/services/api'
import { getCampaignData } from '@/data/campaigns'

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
    _navigationPromise: null,
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
      if (this._navigationPromise) return this._navigationPromise
      const staticNav = [
        { type: 'competition', path_segment: 'earth', slug: 'earth' },
        { type: 'competition', path_segment: 'monuments', slug: 'monuments' },
        { type: 'competition', path_segment: 'folklore', slug: 'folklore' },
        { type: 'competition', path_segment: 'africa', slug: 'africa' },
        { type: 'competition', path_segment: 'food', slug: 'food' },
        { type: 'competition', path_segment: 'public_art', slug: 'public_art' },
        { type: 'competition', path_segment: 'science', slug: 'science' },
      ]
      const staticLookup = { earth: 'earth', monuments: 'monuments', folklore: 'folklore', africa: 'africa', food: 'food', public_art: 'public_art', science: 'science' }
      this.loading.navigation = true
      this.error = null
      this._navigationPromise = (async () => {
        try {
          let nav = []
          try {
            const campaigns = await fetchToolforgeCampaigns()
            if (campaigns?.campaigns?.length) {
              nav = campaigns.campaigns.map((c) => ({
                type: 'competition',
                label: c.name,
                slug: c.slug,
                path_segment: c.path_segment || c.slug,
              }))
            }
          } catch (_) {}
          if (!nav.length) nav = staticNav
          this.navigation = nav
          this.segmentLookup = nav.reduce((acc, entry) => {
            if (entry.type === 'competition' && entry.path_segment) {
              acc[entry.path_segment] = entry.path_segment
            }
            return acc
          }, {})
        } catch (error) {
          console.error('Error loading navigation:', error)
          this.navigation = staticNav
          this.segmentLookup = staticLookup
        } finally {
          this.loading.navigation = false
          this._navigationPromise = null
        }
      })()
      return this._navigationPromise
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
        // Prefer on-demand SQL via Toolforge: GET /api/data/<slug>/<year>/<country>
        try {
          const data = await fetchToolforgeCountryDetail(campaignSlug, year, country)
          return data
        } catch (onDemandErr) {
          try {
            const data = await fetchToolforgeCampaignData(campaignSlug)
            const yearData = data.years?.find(y => y.year === year)
            if (!yearData) throw new Error(`No data found for year ${year}`)
            const countryData = yearData.country_stats?.find(c =>
              (c.name || c.country || '').toLowerCase().replace(/\s+/g, '_') === country.toLowerCase().replace(/\s+/g, '_') ||
              (c.name || c.country || '').toLowerCase() === country.toLowerCase()
            )
            if (!countryData) throw new Error(`No data found for country ${country}`)
            const name = countryData.name ?? countryData.country ?? country
            return {
              campaign: data.campaign_name || campaignSlug,
              year: year,
              country: name,
              category_name: `Images_from_${(data.campaign_name || campaignSlug).replace(/\s+/g, '_')}_${year}_in_${name.replace(/\s+/g, '_')}`,
              total_uploads: countryData.uploads ?? 0,
              total_uploaders: countryData.uploaders ?? 0,
              total_images_used: countryData.images_used ?? 0,
              total_new_uploaders: countryData.new_uploaders ?? 0,
              daily_stats: countryData.daily_stats || []
            }
          } catch (apiErr) {
            const staticData = getCampaignData(campaignSlug)
            if (!staticData?.years) throw apiErr
            const yearData = staticData.years.find(y => y.year === year)
            if (!yearData?.country_rows) throw apiErr
            const countryData = yearData.country_rows.find(c =>
              (c.country || '').toLowerCase().replace(/\s+/g, '_') === country.toLowerCase().replace(/\s+/g, '_') ||
              (c.country || '').toLowerCase() === country.toLowerCase()
            )
            if (!countryData) throw apiErr
            const name = countryData.country || country
            const campaignName = staticData.campaign_name || campaignSlug
            return {
              campaign: campaignName,
              year: year,
              country: name,
              category_name: `Images_from_${campaignName.replace(/\s+/g, '_')}_${year}_in_${name.replace(/\s+/g, '_')}`,
              total_uploads: countryData.images ?? 0,
              total_uploaders: countryData.uploaders ?? 0,
              total_images_used: countryData.images_used ?? 0,
              total_new_uploaders: countryData.new_uploaders ?? 0,
              daily_stats: []
            }
          }
        }
      } catch (error) {
        console.error('Error loading campaign country detail:', error)
        this.error = error.message || error
        throw error
      }
    },
  },
})

