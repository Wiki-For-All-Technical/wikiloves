<script setup>
const campaigns = [
  { name: 'Wiki Loves Earth', segment: 'earth', logo: '/campaign-logos/Wiki_Loves_Earth_Logo.png', color: '#10b981', bg: '#ecfdf5' },
  { name: 'Wiki Loves Monuments', segment: 'monuments', logo: '/campaign-logos/WL_Monuments_2011_d.png', color: '#ef4444', bg: '#fef2f2' },
  { name: 'Wiki Loves Folklore', segment: 'folklore', logo: '/campaign-logos/Wiki_Loves_Folklore_Logo.svg.png', color: '#8b5cf6', bg: '#f5f3ff' },
  { name: 'Wiki Science Competition', segment: 'science', logo: '/campaign-logos/Logo_for_Wiki_Science_Competition.svg.png', color: '#2563eb', bg: '#eff6ff' },
  { name: 'Wiki Loves Public Art', segment: 'public_art', logo: '/campaign-logos/Wikilovespublicart_4.svg.png', color: '#ec4899', bg: '#fdf2f8' },
  { name: 'Wiki Loves Africa', segment: 'africa', logo: '/campaign-logos/Wiki_Loves_Africa_Logo_Vectorized.svg.png', color: '#f59e0b', bg: '#fffbeb' },
  { name: 'Wiki Loves Food', segment: 'food', logo: '/campaign-logos/Wiki_Loves_Food_logo_2015.png', color: '#14b8a6', bg: '#f0fdfa' },
]
</script>

<template>
  <div class="home">
    <!-- Hero -->
    <section class="hero">
      <div class="hero-inner">
        <div class="hero-text">
          <h1 class="hero-title">
            Photo competitions for
            <span class="hero-accent">Wikimedia Commons</span>
          </h1>
          <p class="hero-description">
            A series of annual photo competitions organized by Wikimedia communities worldwide
            to collect freely licensed photos of cultural heritage, monuments, nature, food, and more
            for <a href="https://www.wikipedia.org/" target="_blank" rel="noopener">Wikipedia</a> and
            <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener">Wikimedia Commons</a>.
          </p>
          <div class="hero-actions">
            <router-link to="/comparison" class="btn btn-primary">Explore Statistics</router-link>
            <a href="https://commons.wikimedia.org/wiki/Commons:Wiki_Loves" target="_blank" rel="noopener" class="btn btn-outline">Learn More</a>
          </div>
        </div>
        <div class="hero-visual">
          <div class="hero-grid-logos">
            <div v-for="c in campaigns.slice(0, 4)" :key="c.segment" class="hero-logo-bubble" :style="{ background: c.bg }">
              <img :src="c.logo" :alt="c.name" />
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Campaigns -->
    <section class="campaigns">
      <div class="campaigns-inner">
        <h2 class="section-heading">Our Campaigns</h2>
        <div class="campaigns-grid">
          <router-link
            v-for="c in campaigns"
            :key="c.segment"
            :to="`/${c.segment}`"
            class="campaign-card"
          >
            <div class="card-logo" :style="{ background: c.bg }">
              <img :src="c.logo" :alt="c.name" />
            </div>
            <div class="card-body">
              <h3 class="card-title">{{ c.name }}</h3>
              <span class="card-arrow">&rarr;</span>
            </div>
          </router-link>
        </div>
      </div>
    </section>

    <!-- Footer -->
    <footer class="home-footer">
      <p>Wiki Loves Competitions Tools &middot; Data from <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener">Wikimedia Commons</a></p>
      <p class="footer-sub">Source available under <a href="https://www.gnu.org/licenses/gpl-3.0.html" target="_blank">GPL v3</a></p>
    </footer>
  </div>
</template>

<style scoped>
.home {
  min-height: 100vh;
}

/* Hero */
.hero {
  background: var(--bg-primary);
  border-bottom: 1px solid var(--border-color);
}

.hero-inner {
  max-width: 1200px;
  margin: 0 auto;
  padding: 4rem 2rem;
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 3rem;
  align-items: center;
}

.hero-title {
  margin: 0 0 1.25rem;
  font-size: clamp(2rem, 4vw, 3rem);
  font-weight: 800;
  line-height: 1.15;
  letter-spacing: -0.03em;
  color: var(--text-primary);
}

.hero-accent {
  color: var(--color-accent);
}

.hero-description {
  margin: 0 0 2rem;
  font-size: 1.0625rem;
  line-height: 1.7;
  color: var(--text-secondary);
  max-width: 520px;
}

.hero-description a {
  color: var(--color-accent);
  font-weight: 500;
}

.hero-actions {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.btn {
  display: inline-flex;
  align-items: center;
  padding: 0.625rem 1.5rem;
  border-radius: var(--radius-sm);
  font-size: 0.9375rem;
  font-weight: 600;
  text-decoration: none;
  transition: all 0.15s;
  border: 2px solid transparent;
}

.btn-primary {
  background: var(--color-accent);
  color: #fff;
}
.btn-primary:hover { background: var(--color-accent-hover); text-decoration: none; }

.btn-outline {
  border-color: var(--border-strong);
  color: var(--text-primary);
  background: transparent;
}
.btn-outline:hover { border-color: var(--color-accent); color: var(--color-accent); text-decoration: none; }

.hero-visual {
  display: flex;
  align-items: center;
  justify-content: center;
}

.hero-grid-logos {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 1.25rem;
}

.hero-logo-bubble {
  width: 130px;
  height: 130px;
  border-radius: var(--radius-lg);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 1.5rem;
  transition: transform 0.2s;
}

.hero-logo-bubble:hover {
  transform: scale(1.05);
}

.hero-logo-bubble img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

/* Campaigns */
.campaigns {
  background: var(--bg-page);
}

.campaigns-inner {
  max-width: 1200px;
  margin: 0 auto;
  padding: 3.5rem 2rem;
}

.section-heading {
  margin: 0 0 2rem;
  font-size: 1.75rem;
  font-weight: 800;
  color: var(--text-primary);
  letter-spacing: -0.02em;
}

.campaigns-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
  gap: 1.25rem;
}

.campaign-card {
  display: flex;
  align-items: center;
  gap: 1rem;
  padding: 1rem 1.25rem;
  background: var(--bg-card);
  border: 1px solid var(--border-color);
  border-radius: var(--radius-md);
  text-decoration: none;
  color: inherit;
  transition: all 0.2s;
}

.campaign-card:hover {
  border-color: var(--color-accent);
  box-shadow: var(--shadow-md);
  text-decoration: none;
  transform: translateY(-2px);
}

.card-logo {
  width: 56px;
  height: 56px;
  border-radius: var(--radius-sm);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0.5rem;
  flex-shrink: 0;
}

.card-logo img {
  max-width: 100%;
  max-height: 100%;
  object-fit: contain;
}

.card-body {
  flex: 1;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.card-title {
  margin: 0;
  font-size: 0.9375rem;
  font-weight: 600;
  color: var(--text-primary);
}

.card-arrow {
  color: var(--text-muted);
  font-size: 1.25rem;
  transition: transform 0.15s, color 0.15s;
}

.campaign-card:hover .card-arrow {
  transform: translateX(3px);
  color: var(--color-accent);
}

/* Footer */
.home-footer {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
  text-align: center;
  border-top: 1px solid var(--border-color);
  font-size: 0.875rem;
  color: var(--text-muted);
}

.home-footer p { margin: 0.25rem 0; }
.home-footer a { color: var(--text-secondary); }
.home-footer a:hover { color: var(--color-accent); }
.footer-sub { font-size: 0.8125rem; }

@media (max-width: 768px) {
  .hero-inner {
    grid-template-columns: 1fr;
    padding: 2.5rem 1.5rem;
    gap: 2rem;
  }

  .hero-visual { display: none; }

  .campaigns-inner { padding: 2.5rem 1.5rem; }

  .campaigns-grid {
    grid-template-columns: 1fr;
  }
}
</style>
