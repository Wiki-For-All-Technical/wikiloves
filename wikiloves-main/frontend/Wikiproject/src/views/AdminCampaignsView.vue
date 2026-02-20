<script setup>
import { ref, onMounted } from 'vue'
import { useAuthStore } from '@/stores/auth'
import { useRouter } from 'vue-router'
import axios from 'axios'

const isDev = import.meta.env.DEV
const ADMIN_BASE = isDev ? '/toolforge-api/admin' : '/api/admin'

const auth = useAuthStore()
const router = useRouter()

const campaigns = ref([])
const loading = ref(true)
const error = ref(null)
const showForm = ref(false)
const saving = ref(false)

const form = ref({
  key: '',
  name: '',
  slug: '',
  quarry_category: '',
  start_month: '',
})

const MONTHS = [
  { value: '', label: 'Default' },
  { value: 1, label: 'January' }, { value: 2, label: 'February' },
  { value: 3, label: 'March' }, { value: 4, label: 'April' },
  { value: 5, label: 'May' }, { value: 6, label: 'June' },
  { value: 7, label: 'July' }, { value: 8, label: 'August' },
  { value: 9, label: 'September' }, { value: 10, label: 'October' },
  { value: 11, label: 'November' }, { value: 12, label: 'December' },
]

async function fetchCampaigns() {
  loading.value = true
  error.value = null
  try {
    const { data } = await axios.get(ADMIN_BASE + '/campaigns', { withCredentials: true })
    campaigns.value = data
  } catch (e) {
    if (e.response?.status === 401) {
      router.push('/')
    } else if (e.response?.status === 403) {
      error.value = 'You do not have admin access.'
    } else {
      error.value = 'Failed to load campaigns.'
    }
  } finally {
    loading.value = false
  }
}

function resetForm() {
  form.value = { key: '', name: '', slug: '', quarry_category: '', start_month: '' }
}

async function createCampaign() {
  saving.value = true
  error.value = null
  try {
    const body = { ...form.value }
    if (!body.slug) body.slug = `wiki-loves-${body.key}`
    if (!body.quarry_category) body.quarry_category = body.key
    if (!body.start_month) delete body.start_month
    await axios.post(ADMIN_BASE + '/campaigns', body, { withCredentials: true })
    resetForm()
    showForm.value = false
    await fetchCampaigns()
  } catch (e) {
    error.value = e.response?.data?.error || 'Failed to create campaign.'
  } finally {
    saving.value = false
  }
}

async function deleteCampaign(key) {
  if (!confirm(`Delete campaign "${key}"? This cannot be undone.`)) return
  try {
    await axios.delete(`${ADMIN_BASE}/campaigns/${key}`, { withCredentials: true })
    await fetchCampaigns()
  } catch (e) {
    error.value = e.response?.data?.error || 'Failed to delete.'
  }
}

onMounted(async () => {
  await auth.fetchUser()
  if (!auth.isLoggedIn || !auth.isAdmin) {
    router.push('/')
    return
  }
  fetchCampaigns()
})
</script>

<template>
  <div class="page">
    <div class="page-inner">
      <nav class="breadcrumb" aria-label="Breadcrumb">
        <router-link to="/">Home</router-link>
        <span class="sep">/</span>
        <span class="current">Campaign Management</span>
      </nav>

      <header class="page-hero">
        <h1 class="page-title">Campaign Management</h1>
        <p class="page-subtitle">Create and manage Wiki Loves campaigns. New campaigns will automatically use the data fetcher pipeline.</p>
      </header>

      <div v-if="error" class="error-banner">{{ error }}</div>

      <!-- Create Campaign -->
      <section class="action-bar">
        <button v-if="!showForm" class="btn btn-primary" @click="showForm = true">+ New Campaign</button>
        <div v-else class="form-card">
          <h3 class="form-title">Create New Campaign</h3>
          <form @submit.prevent="createCampaign" class="form-grid">
            <div class="form-field">
              <label>Key <span class="req">*</span></label>
              <input v-model="form.key" type="text" placeholder="e.g. earth_2026" required pattern="[a-z][a-z0-9_]{1,30}" />
              <span class="field-hint">Lowercase, letters/numbers/underscores</span>
            </div>
            <div class="form-field">
              <label>Display Name <span class="req">*</span></label>
              <input v-model="form.name" type="text" placeholder="e.g. Wiki Loves Earth 2026" required />
            </div>
            <div class="form-field">
              <label>Slug</label>
              <input v-model="form.slug" type="text" :placeholder="`wiki-loves-${form.key || '...'}`" />
              <span class="field-hint">Auto-generated if empty</span>
            </div>
            <div class="form-field">
              <label>Category</label>
              <input v-model="form.quarry_category" type="text" :placeholder="form.key || 'earth'" />
              <span class="field-hint">Wikimedia Commons category prefix</span>
            </div>
            <div class="form-field">
              <label>Start Month</label>
              <select v-model="form.start_month">
                <option v-for="m in MONTHS" :key="m.value" :value="m.value">{{ m.label }}</option>
              </select>
            </div>
            <div class="form-actions">
              <button type="submit" class="btn btn-primary" :disabled="saving">
                {{ saving ? 'Creating...' : 'Create Campaign' }}
              </button>
              <button type="button" class="btn btn-secondary" @click="showForm = false; resetForm()">Cancel</button>
            </div>
          </form>
        </div>
      </section>

      <!-- Campaign List -->
      <section class="table-section">
        <h2 class="section-heading">All Campaigns</h2>
        <div v-if="loading" class="loading-state">
          <div class="spinner"></div>
        </div>
        <div v-else class="table-wrap">
          <table class="data-table">
            <thead>
              <tr>
                <th>Key</th>
                <th>Name</th>
                <th>Slug</th>
                <th>Category</th>
                <th>Type</th>
                <th></th>
              </tr>
            </thead>
            <tbody>
              <tr v-for="c in campaigns" :key="c.key">
                <td class="td-key"><code>{{ c.key }}</code></td>
                <td class="td-name">{{ c.name }}</td>
                <td><code>{{ c.slug }}</code></td>
                <td><code>{{ c.quarry_category }}</code></td>
                <td>
                  <span v-if="c.is_custom" class="badge badge-custom">Custom</span>
                  <span v-else class="badge badge-built-in">Built-in</span>
                </td>
                <td class="td-actions">
                  <button v-if="c.is_custom" class="btn-icon btn-icon--danger" title="Delete" @click="deleteCampaign(c.key)">
                    <svg width="16" height="16" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M9 2a1 1 0 00-.894.553L7.382 4H4a1 1 0 000 2v10a2 2 0 002 2h8a2 2 0 002-2V6a1 1 0 100-2h-3.382l-.724-1.447A1 1 0 0011 2H9zM7 8a1 1 0 012 0v6a1 1 0 11-2 0V8zm5-1a1 1 0 00-1 1v6a1 1 0 102 0V8a1 1 0 00-1-1z" clip-rule="evenodd"/></svg>
                  </button>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>
    </div>
  </div>
</template>

<style scoped>
.page { min-height: 100vh; }

.page-inner {
  max-width: 1100px;
  margin: 0 auto;
  padding: 2rem;
}

.breadcrumb { font-size: 0.875rem; margin-bottom: 2rem; color: var(--text-muted); }
.breadcrumb a { color: var(--color-accent); text-decoration: none; font-weight: 500; }
.breadcrumb a:hover { text-decoration: underline; }
.sep { margin: 0 0.5rem; }
.current { color: var(--text-primary); font-weight: 600; }

.page-hero { margin-bottom: 2rem; }
.page-title {
  margin: 0 0 0.375rem;
  font-size: clamp(1.75rem, 4vw, 2.25rem);
  font-weight: 800;
  letter-spacing: -0.03em;
  color: var(--text-primary);
}
.page-subtitle { margin: 0; font-size: 0.9375rem; color: var(--text-secondary); max-width: 600px; line-height: 1.6; }

.error-banner {
  padding: 0.75rem 1rem;
  background: #fef2f2;
  border: 1px solid #fecaca;
  border-radius: 8px;
  color: #dc2626;
  font-size: 0.875rem;
  font-weight: 500;
  margin-bottom: 1.5rem;
}

.action-bar { margin-bottom: 2rem; }

.btn {
  padding: 0.5rem 1.25rem;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  border: none;
  transition: all 0.15s;
}
.btn-primary { background: var(--color-accent); color: #fff; }
.btn-primary:hover { opacity: 0.9; }
.btn-primary:disabled { opacity: 0.5; cursor: not-allowed; }
.btn-secondary { background: var(--bg-secondary, #f1f5f9); color: var(--text-secondary); border: 1px solid var(--border-color); }
.btn-secondary:hover { background: var(--bg-hover); }

.form-card {
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md, 12px);
  padding: 1.5rem;
  box-shadow: var(--shadow-sm);
}

.form-title { margin: 0 0 1.25rem; font-size: 1.125rem; font-weight: 700; color: var(--text-primary); }

.form-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1rem;
}

.form-field { display: flex; flex-direction: column; gap: 0.25rem; }
.form-field label { font-size: 0.8125rem; font-weight: 600; color: var(--text-secondary); }
.req { color: #ef4444; }
.form-field input,
.form-field select {
  padding: 0.5rem 0.75rem;
  border: 1px solid var(--border-color);
  border-radius: 6px;
  font-size: 0.875rem;
  background: var(--bg-card);
  color: var(--text-primary);
}
.form-field input:focus,
.form-field select:focus { outline: none; border-color: var(--color-accent); box-shadow: 0 0 0 2px rgba(37,99,235,0.15); }
.field-hint { font-size: 0.75rem; color: var(--text-muted); }

.form-actions {
  grid-column: 1 / -1;
  display: flex;
  gap: 0.75rem;
  padding-top: 0.5rem;
}

/* Table */
.section-heading { margin: 0 0 1rem; font-size: 1.25rem; font-weight: 700; color: var(--text-primary); }

.table-wrap {
  overflow-x: auto;
  border-radius: var(--radius-md, 12px);
  border: 1px solid var(--border-color);
  background: var(--bg-card);
  box-shadow: var(--shadow-sm);
}

.data-table { width: 100%; border-collapse: collapse; font-size: 0.9375rem; }
.data-table thead tr { background: var(--bg-secondary); border-bottom: 2px solid var(--border-color); }
.data-table th {
  padding: 0.75rem 1rem;
  text-align: left;
  font-weight: 700;
  color: var(--text-secondary);
  font-size: 0.75rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
.data-table td { padding: 0.75rem 1rem; border-bottom: 1px solid var(--border-color); color: var(--text-primary); }
.data-table tbody tr:last-child td { border-bottom: none; }
.data-table tbody tr:hover { background: var(--bg-hover); }

.td-key { font-weight: 600; }
.td-name { font-weight: 600; }
.td-actions { text-align: right; }

code {
  padding: 0.125rem 0.375rem;
  background: var(--bg-secondary, #f1f5f9);
  border-radius: 4px;
  font-size: 0.8125rem;
}

.badge {
  display: inline-block;
  padding: 0.125rem 0.5rem;
  border-radius: 999px;
  font-size: 0.75rem;
  font-weight: 600;
}
.badge-built-in { background: #eff6ff; color: #2563eb; }
.badge-custom { background: #ecfdf5; color: #059669; }

.btn-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 32px;
  height: 32px;
  border: none;
  border-radius: 6px;
  background: transparent;
  color: var(--text-muted);
  cursor: pointer;
  transition: all 0.15s;
}
.btn-icon--danger:hover { background: #fef2f2; color: #ef4444; }

.loading-state { display: flex; justify-content: center; padding: 3rem 0; }
.spinner {
  width: 32px; height: 32px;
  border: 3px solid var(--border-color);
  border-top-color: var(--color-accent);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

@media (max-width: 768px) {
  .page-inner { padding: 1.5rem; }
  .form-grid { grid-template-columns: 1fr; }
}
</style>
