import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path: '/',
      name: 'home',
      component: HomeView,
    },
    {
      path: '/comparison',
      name: 'comparison',
      component: () => import('../views/ComparisonView.vue'),
    },
    {
      path: '/country/:slug',
      name: 'country',
      component: () => import('../views/CountryView.vue'),
    },
    {
      path: '/:segment/:year/:country',
      name: 'campaign-country-year',
      component: () => import('../views/CampaignCountryView.vue'),
    },
    {
      path: '/:segment/:year',
      name: 'competition-year',
      component: () => import('../views/CompetitionView.vue'),
    },
    {
      path: '/:segment',
      name: 'competition',
      component: () => import('../views/CompetitionView.vue'),
    },
  ],
})

export default router
