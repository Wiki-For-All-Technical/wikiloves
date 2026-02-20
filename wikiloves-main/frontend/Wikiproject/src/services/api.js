import axios from 'axios'

// Dev: Vite proxy handles /toolforge-api → Toolforge
// Prod: frontend is served from the same origin, so /api works directly
const isDev = import.meta.env.DEV
const TOOLFORGE_API_BASE = isDev
  ? '/toolforge-api'
  : (import.meta.env.VITE_API_BASE ?? '/api')

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE ?? TOOLFORGE_API_BASE,
})

const mapResponse = (promise) => promise.then((res) => res.data)

// Toolforge API endpoints (automatically uses proxy in dev, direct API in prod)
export const fetchToolforgeCampaignData = (campaignSlug) => 
  mapResponse(axios.get(`${TOOLFORGE_API_BASE}/data/${campaignSlug}`))

export const fetchToolforgeCampaignSummary = (campaignSlug) => 
  mapResponse(axios.get(`${TOOLFORGE_API_BASE}/data/${campaignSlug}/summary`))

export const fetchToolforgeCampaignQuery = (campaignSlug, year = null) => {
  // Execute SQL query directly and get raw results
  const params = year ? { year } : {}
  return mapResponse(axios.get(`${TOOLFORGE_API_BASE}/query/${campaignSlug}`, { params }))
}

export const fetchToolforgeCampaigns = () => 
  mapResponse(axios.get(`${TOOLFORGE_API_BASE}/campaigns`))

const TOOLFORGE_COUNTRY_TIMEOUT_MS = 60000
const TOOLFORGE_UPLOADERS_TIMEOUT_MS = 180000

export const fetchToolforgeCountryDetail = (campaignSlug, year, country) => {
  const path = `${TOOLFORGE_API_BASE}/data/${campaignSlug}/${year}/${encodeURIComponent(country)}`
  return mapResponse(axios.get(path, { timeout: TOOLFORGE_COUNTRY_TIMEOUT_MS }))
}

export const fetchToolforgeCountryUploaders = (campaignSlug, year, country) => {
  const path = `${TOOLFORGE_API_BASE}/data/${campaignSlug}/${year}/${encodeURIComponent(country)}/uploaders`
  return mapResponse(axios.get(path, { timeout: TOOLFORGE_UPLOADERS_TIMEOUT_MS }))
}

// Legacy endpoints (for backward compatibility)
export const fetchOverview = () => mapResponse(api.get('/overview'))
export const fetchNavigation = () => mapResponse(api.get('/navigation'))
export const fetchCompetitions = (category = null) => {
  const params = category ? { category } : {}
  return mapResponse(api.get('/competitions', { params }))
}
export const fetchCompetition = (slug) => mapResponse(api.get(`/competitions/${slug}`))
export const fetchCountries = () => mapResponse(api.get('/countries'))
export const fetchCountry = (slug) => mapResponse(api.get(`/countries/${slug}`))
export const fetchComparison = (year = null) => {
  const params = year ? { year } : {}
  return mapResponse(api.get('/statistics/comparison', { params }))
}
export const fetchTrends = (campaigns = null) => {
  const params = campaigns ? { campaigns } : {}
  return mapResponse(api.get('/statistics/trends', { params }))
}

