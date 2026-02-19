<script setup>
const campaigns = [
  { name: 'Wiki Loves Earth', year: 2013, desc: 'Natural heritage and protected areas' },
  { name: 'Wiki Loves Monuments', year: 2010, desc: 'Cultural heritage and historic monuments' },
  { name: 'Wiki Loves Folklore', year: 2021, desc: 'Intangible cultural heritage and traditions' },
  { name: 'Wiki Science Competition', year: 2015, desc: 'Scientific images and illustrations' },
  { name: 'Wiki Loves Africa', year: 2014, desc: 'African culture, nature, and heritage' },
  { name: 'Wiki Loves Food', year: 2021, desc: 'Food culture and culinary traditions' },
  { name: 'Wiki Loves Public Art', year: 2013, desc: 'Public art and sculptures' },
]
</script>

<template>
  <div class="about">
    <div class="about-inner">
      <h1 class="about-title">About Wiki Loves</h1>

      <section class="about-section">
        <h2>What is this?</h2>
        <p>
          This tool provides statistics and analytics for the
          <strong>Wiki Loves</strong> series of photo competitions organized by
          <a href="https://meta.wikimedia.org/" target="_blank" rel="noopener">Wikimedia</a> communities worldwide.
          It tracks uploads, contributors, image usage, and participation across countries and years.
        </p>
      </section>

      <section class="about-section">
        <h2>Campaigns</h2>
        <p>
          We currently track <strong>{{ campaigns.length }} campaigns</strong> spanning over a decade of community photography.
        </p>
        <div class="campaigns-table">
          <div class="table-row table-header">
            <span>Campaign</span>
            <span>Since</span>
            <span>Focus</span>
          </div>
          <div v-for="c in campaigns" :key="c.name" class="table-row">
            <span class="cell-name">{{ c.name }}</span>
            <span class="cell-year">{{ c.year }}</span>
            <span class="cell-desc">{{ c.desc }}</span>
          </div>
        </div>
      </section>

      <section class="about-section">
        <h2>Data Source</h2>
        <p>
          All data is fetched directly from the
          <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener">Wikimedia Commons</a>
          database replicas via
          <a href="https://wikitech.wikimedia.org/wiki/Help:Toolforge" target="_blank" rel="noopener">Toolforge</a>.
          Statistics are updated periodically and include upload counts, unique contributors,
          new contributor tracking, and image usage across Wikipedia and sister projects.
        </p>
      </section>

      <section class="about-section">
        <h2>How it works</h2>
        <ul class="how-list">
          <li>
            <strong>Data collection</strong> &mdash; SQL queries run against Wikimedia Commons database replicas
            to extract upload metadata from campaign categories.
          </li>
          <li>
            <strong>Processing</strong> &mdash; Raw data is aggregated by country and year, with contributor
            tracking and image usage statistics from <code>globalimagelinks</code>.
          </li>
          <li>
            <strong>Presentation</strong> &mdash; Processed JSON is served via a Toolforge API and
            rendered by this Vue.js frontend.
          </li>
        </ul>
      </section>

      <section class="about-section">
        <h2>Links</h2>
        <div class="links-grid">
          <a href="https://commons.wikimedia.org/wiki/Commons:Wiki_Loves" target="_blank" rel="noopener" class="link-card">
            <span class="link-label">Wiki Loves on Commons</span>
            <span class="link-url">commons.wikimedia.org</span>
          </a>
          <a href="https://tools.wmflabs.org/wikiloves/" target="_blank" rel="noopener" class="link-card">
            <span class="link-label">Original Wiki Loves Tool</span>
            <span class="link-url">tools.wmflabs.org</span>
          </a>
          <a href="https://wikitech.wikimedia.org/wiki/Help:Toolforge" target="_blank" rel="noopener" class="link-card">
            <span class="link-label">Toolforge Documentation</span>
            <span class="link-url">wikitech.wikimedia.org</span>
          </a>
        </div>
      </section>

      <section class="about-section">
        <h2>License</h2>
        <p>
          This tool is open source, available under the
          <a href="https://www.gnu.org/licenses/gpl-3.0.html" target="_blank" rel="noopener">GNU General Public License v3</a>.
          Data from Wikimedia Commons is available under
          <a href="https://creativecommons.org/licenses/by-sa/4.0/" target="_blank" rel="noopener">CC BY-SA 4.0</a>.
        </p>
      </section>
    </div>
  </div>
</template>

<style scoped>
.about {
  min-height: 100vh;
  background: var(--bg-page);
}

.about-inner {
  max-width: 800px;
  margin: 0 auto;
  padding: 3rem 2rem 4rem;
}

.about-title {
  font-size: 2.25rem;
  font-weight: 800;
  letter-spacing: -0.03em;
  color: var(--text-primary);
  margin: 0 0 2.5rem;
}

.about-section {
  margin-bottom: 2.5rem;
}

.about-section h2 {
  font-size: 1.25rem;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 0.75rem;
  letter-spacing: -0.01em;
}

.about-section p {
  font-size: 1rem;
  line-height: 1.75;
  color: var(--text-secondary);
  margin: 0 0 1rem;
}

.about-section a {
  color: var(--color-accent);
  font-weight: 500;
}

.about-section a:hover {
  text-decoration: underline;
}

/* Campaigns table */
.campaigns-table {
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  overflow: hidden;
  margin-top: 1rem;
}

.table-row {
  display: grid;
  grid-template-columns: 1fr 80px 1.5fr;
  padding: 0.75rem 1rem;
  border-bottom: 1px solid var(--border-color);
  font-size: 0.9375rem;
  color: var(--text-secondary);
}

.table-row:last-child {
  border-bottom: none;
}

.table-header {
  background: var(--bg-primary);
  font-weight: 600;
  color: var(--text-primary);
  font-size: 0.8125rem;
  text-transform: uppercase;
  letter-spacing: 0.04em;
}

.cell-name {
  font-weight: 600;
  color: var(--text-primary);
}

.cell-year {
  text-align: center;
  color: var(--text-muted);
}

/* How list */
.how-list {
  list-style: none;
  padding: 0;
  margin: 0;
  display: flex;
  flex-direction: column;
  gap: 0.75rem;
}

.how-list li {
  padding: 1rem 1.25rem;
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  font-size: 0.9375rem;
  line-height: 1.65;
  color: var(--text-secondary);
}

.how-list code {
  background: var(--bg-hover);
  padding: 0.125rem 0.375rem;
  border-radius: 4px;
  font-size: 0.85em;
}

/* Links grid */
.links-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
  gap: 0.75rem;
  margin-top: 0.75rem;
}

.link-card {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
  padding: 1rem 1.25rem;
  background: var(--bg-primary);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  text-decoration: none;
  transition: all 0.15s;
}

.link-card:hover {
  border-color: var(--color-accent);
  box-shadow: var(--shadow-md);
  transform: translateY(-1px);
  text-decoration: none;
}

.link-label {
  font-weight: 600;
  font-size: 0.9375rem;
  color: var(--text-primary);
}

.link-url {
  font-size: 0.8125rem;
  color: var(--text-muted);
}

@media (max-width: 640px) {
  .about-inner {
    padding: 2rem 1.5rem 3rem;
  }

  .about-title {
    font-size: 1.75rem;
  }

  .table-row {
    grid-template-columns: 1fr 60px;
  }

  .cell-desc {
    display: none;
  }

  .links-grid {
    grid-template-columns: 1fr;
  }
}
</style>
