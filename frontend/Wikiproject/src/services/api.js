import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE ?? 'http://127.0.0.1:5000/api',
})

const mapResponse = (promise) => promise.then((res) => res.data)

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

