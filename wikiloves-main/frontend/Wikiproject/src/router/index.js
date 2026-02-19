import { createRouter, createWebHistory } from 'vue-router'
import HomeView from '../views/HomeView.vue'

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  scrollBehavior(to, from, savedPosition) {
    if (savedPosition) return savedPosition
    if (to.hash) return { el: to.hash }
    return { top: 0 }
  },
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
      path: '/about',
      name: 'about',
      component: () => import('../views/AboutView.vue'),
    },
    {
      path: '/science',
      name: 'science',
      component: () => import('../views/CampaignView.vue'),
      props: { slug: 'science' },
    },
    {
      path: '/folklore',
      name: 'folklore',
      component: () => import('../views/CampaignView.vue'),
      props: { slug: 'folklore' },
    },
    {
      path: '/africa',
      name: 'africa',
      component: () => import('../views/CampaignView.vue'),
      props: { slug: 'africa' },
    },
    {
      path: '/food',
      name: 'food',
      component: () => import('../views/CampaignView.vue'),
      props: { slug: 'food' },
    },
    {
      path: '/public_art',
      name: 'public_art',
      component: () => import('../views/CampaignView.vue'),
      props: { slug: 'public_art' },
    },
    {
      path: '/earth',
      name: 'earth',
      component: () => import('../views/CampaignView.vue'),
      props: { slug: 'earth' },
    },
    {
      path: '/monuments',
      name: 'monuments',
      component: () => import('../views/CampaignView.vue'),
      props: { slug: 'monuments' },
    },
    {
      path: '/:slug/:year',
      name: 'campaign-year',
      component: () => import('../views/CampaignYearView.vue'),
      props: true,
      beforeEnter: (to, _from, next) => {
        const campaignSlugs = ['earth', 'folklore', 'africa', 'food', 'public_art', 'monuments', 'science']
        if (campaignSlugs.includes(to.params.slug) && /^\d+$/.test(to.params.year)) return next()
        next({ path: '/' })
      },
    },
    {
      path: '/images',
      name: 'images',
      component: () => import('../views/ImagesView.vue'),
    },
    {
      path: '/statistics',
      name: 'statistics',
      component: () => import('../views/StatisticsDashboardView.vue'),
    },
    {
      path: '/country/:slug',
      name: 'country',
      component: () => import('../views/CountryView.vue'),
    },
    {
      path: '/monuments/2025/India',
      name: 'monuments-2025-india',
      component: () => import('../views/Monuments2025IndiaView.vue'),
    },
    {
      path: '/:segment/:year/:country/users',
      name: 'campaign-country-users',
      component: () => import('../views/CampaignCountryUsersView.vue'),
    },
    {
      path: '/:segment/:year/:country',
      name: 'campaign-country-year',
      component: () => import('../views/CampaignCountryView.vue'),
    },
  ],
})

export default router
