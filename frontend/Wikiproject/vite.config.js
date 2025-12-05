/* eslint-env node */
import process from 'node:process'
import { fileURLToPath, URL } from 'node:url'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

// https://vite.dev/config/
const isTest = process.env.VITEST

export default defineConfig({
  plugins: [
    vue(),
    !isTest && vueDevTools(),
  ].filter(Boolean),
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    },
  },
  server: {
    host: '127.0.0.1', // Listen on IPv4 localhost
    port: 5173,
    strictPort: false, // Allow port to be changed if 5173 is taken
  },
  test: {
    globals: true,
    environment: 'node',
  },
})
