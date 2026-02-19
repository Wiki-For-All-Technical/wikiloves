import './assets/main.css'

import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'

const app = createApp(App)
app.config.errorHandler = (err, instance, info) => {
  console.error('Vue error:', err, info)
  const el = document.getElementById('app')
  if (el && !el.querySelector('[data-error-msg]')) {
    el.innerHTML = '<p data-error-msg style="padding:2rem;font-family:sans-serif;">Something went wrong. Open DevTools (F12) → Console for details.</p>'
  }
}
app.use(createPinia())
app.use(router)
app.mount('#app')
