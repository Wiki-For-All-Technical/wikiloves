import axios from 'axios'

const api = axios.create({
  baseURL: import.meta.env.VITE_API_BASE ?? 'http://127.0.0.1:5000/api',
})

const mapResponse = (promise) => promise.then((res) => res.data)

export const fetchOverview = () => mapResponse(api.get('/overview'))
export const fetchNavigation = () => mapResponse(api.get('/navigation'))
export const fetchCompetitions = () => mapResponse(api.get('/competitions'))
export const fetchCompetition = (slug) => mapResponse(api.get(`/competitions/${slug}`))
export const fetchCountries = () => mapResponse(api.get('/countries'))
export const fetchCountry = (slug) => mapResponse(api.get(`/countries/${slug}`))

