/* eslint-env node */
import process from 'node:process'
import { fileURLToPath, URL } from 'node:url'
import { dirname } from 'node:path'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueDevTools from 'vite-plugin-vue-devtools'

// https://vite.dev/config/
const isTest = process.env.VITEST

// Get the directory of this config file
const __dirname = dirname(fileURLToPath(import.meta.url))

export default defineConfig({
  root: __dirname, // Explicitly set root to config file directory
  base: '/',
  publicDir: 'public',
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
    host: true, // Listen on all interfaces
    port: 5173,
    strictPort: false,
    open: false,
  },
  appType: 'spa',
  test: {
    globals: true,
    environment: 'node',
  },
})
