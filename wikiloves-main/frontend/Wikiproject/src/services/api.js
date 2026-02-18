import axios from 'axios'

// Use proxy in development to avoid CORS, direct API in production
const isDev = import.meta.env.DEV
const TOOLFORGE_API_BASE = isDev 
  ? '/toolforge-api'  // Use proxy in development
  : 'https://wikiloves-data.toolforge.org/api'  // Direct API in production

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

