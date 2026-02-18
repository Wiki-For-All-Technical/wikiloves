<script setup>
import { useRouter } from 'vue-router'
import monumentsLogo from '@/assets/campaign-logos/monuments.svg'
import earthLogo from '@/assets/campaign-logos/earth.svg'

const router = useRouter()

const campaigns = [
  { name: 'Wiki Loves Monuments', path_segment: 'monuments', category: 'international', logo: monumentsLogo },
  { name: 'Wiki Loves Earth', path_segment: 'earth', category: 'international', logo: earthLogo },
  { name: 'Wiki Loves Folklore', path_segment: 'folklore', category: 'international', logo: '/campaign-logos/Wiki_Loves_Folklore_Logo.svg.png' },
  { name: 'Wiki Science Competition', path_segment: 'science', category: 'international', logo: '/campaign-logos/Logo_for_Wiki_Science_Competition.svg.png' },
  { name: 'Wiki Loves Public Art', path_segment: 'public_art', category: 'international', logo: '/campaign-logos/Wikilovespublicart_4.svg.png' },
  { name: 'Wiki Loves Africa', path_segment: 'africa', category: 'regional', logo: '/campaign-logos/Wiki_Loves_Africa_Logo_Vectorized.svg.png' },
  { name: 'Wiki Loves Food', path_segment: 'food', category: 'regional', logo: '/campaign-logos/Wiki_Loves_Food_logo_2015.png' },
]

const categoryLabel = (cat) => cat === 'international' ? 'International' : 'Regional'
</script>

<template>
  <div class="wiki-loves-home">
    <!-- Header: logo + title + nav (WikiPortraits-style) -->
    <header class="site-header">
      <div class="header-inner">
        <router-link to="/" class="logo-link">
          <span class="logo-icon" aria-hidden="true">W</span>
          <span class="logo-text">Wiki Loves</span>
        </router-link>
        <nav class="main-nav">
          <router-link to="/about" class="nav-link">About</router-link>
          <router-link to="/blog" class="nav-link">Blog</router-link>
          <router-link to="/team" class="nav-link">Our Team</router-link>
          <router-link to="/gallery" class="nav-link">Gallery</router-link>
          <router-link to="/events" class="nav-link">Events</router-link>
          <div class="nav-dropdown">
            <a href="#" class="nav-link">Contact <span class="arrow">▼</span></a>
          </div>
          <router-link to="/donate" class="nav-link">Donate</router-link>
          <router-link to="/press" class="nav-link">Press</router-link>
        </nav>
      </div>
    </header>

    <!-- Main: image left, text right -->
    <main class="main-content">
      <div class="hero-grid">
        <div class="hero-image-wrap">
          <img
            src="https://upload.wikimedia.org/wikipedia/commons/a/a4/Tool_labs_logo.svg"
            alt="Tool Labs logo"
            class="hero-image hero-image--logo"
          />
        </div>
        <div class="hero-text">
          <h1 class="hero-title">Wiki Loves</h1>
          <p class="hero-paragraph">
            A series of annual photo competitions to collect freely licensed photos of cultural heritage,
            monuments, food, earth, and more for <a href="https://www.wikipedia.org/" target="_blank" rel="noopener" class="text-link">Wikipedia</a> and
            <a href="https://commons.wikimedia.org/" target="_blank" rel="noopener" class="text-link">Wikimedia Commons</a>.
          </p>
          <p class="hero-paragraph">
            Led by volunteer Wikimedia communities with support from the
            <a href="https://wikimediafoundation.org/" target="_blank" rel="noopener" class="text-link">Wikimedia Foundation</a>,
            local chapters, and partners worldwide. Wiki Loves Monuments, Wiki Loves Earth, Wiki Loves Food,
            and other campaigns have brought millions of images to the commons.
          </p>
          <p class="hero-paragraph">
            The competitions have been covered by media worldwide and continue to grow each year.
          </p>
          <router-link to="/donate" class="donate-link">Donate!</router-link>
        </div>
      </div>

      <!-- Campaigns grid -->
      <section class="campaigns-section">
        <h2 class="campaigns-heading">
          <span class="campaigns-heading-main">Our Campaigns</span>
          <span class="campaigns-heading-accent">Right Now</span>
        </h2>
        <div class="campaigns-grid">
          <router-link
            v-for="campaign in campaigns"
            :key="campaign.path_segment"
            :to="`/${campaign.path_segment}`"
            class="campaign-card"
          >
            <div
              class="campaign-card-visual"
              :class="{ [`campaign-card-visual--${campaign.path_segment}`]: !campaign.logo }"
            >
              <img
                v-if="campaign.logo"
                :src="campaign.logo"
                :alt="campaign.name"
                class="campaign-card-logo"
              />
            </div>
            <div class="campaign-card-body">
              <h3 class="campaign-card-title">{{ campaign.name }}</h3>
              <p class="campaign-card-subtitle">{{ categoryLabel(campaign.category) }}</p>
            </div>
          </router-link>
        </div>
        <div class="campaigns-cta-wrap">
          <router-link to="/comparison" class="campaigns-cta">Explore All Campaigns</router-link>
        </div>
      </section>
    </main>

    <footer class="site-footer">
      <p>Wiki Loves – Photo competitions for Wikimedia Commons.</p>
    </footer>
  </div>
</template>

<style scoped>
.wiki-loves-home {
  min-height: 100vh;
  background: #fff;
  color: #222;
}

/* Header */
.site-header {
  border-bottom: 1px solid #e5e7eb;
  padding: 1rem 2rem;
}

.header-inner {
  max-width: 1200px;
  margin: 0 auto;
  display: flex;
  align-items: center;
  justify-content: space-between;
  flex-wrap: wrap;
  gap: 1rem;
}

.logo-link {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  text-decoration: none;
  color: #222;
  font-weight: 600;
  font-size: 1.25rem;
}

.logo-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 2.25rem;
  height: 2.25rem;
  background: linear-gradient(135deg, #c00 0%, #c00 50%, #fff 50%, #fff 100%);
  color: #fff;
  font-weight: 700;
  font-size: 1.25rem;
  border-radius: 50%;
  font-family: Georgia, serif;
}

.logo-text {
  letter-spacing: -0.02em;
}

.main-nav {
  display: flex;
  align-items: center;
  gap: 1.25rem;
  flex-wrap: wrap;
}

.nav-link {
  color: #222;
  text-decoration: none;
  font-size: 0.9375rem;
}

.nav-link:hover {
  text-decoration: underline;
}

.nav-dropdown .arrow {
  font-size: 0.65rem;
  opacity: 0.8;
}

/* Main content */
.main-content {
  max-width: 1200px;
  margin: 0 auto;
  padding: 2rem;
}

.hero-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 2.5rem;
  align-items: start;
}

.hero-image-wrap {
  position: relative;
  border-radius: 8px;
  overflow: hidden;
  box-shadow: 0 1px 3px rgba(0,0,0,0.1);
}

.hero-image {
  width: 100%;
  height: auto;
  display: block;
  object-fit: cover;
}

.hero-image--logo {
  max-width: 320px;
  margin: 0 auto;
  object-fit: contain;
}

.hero-text {
  padding-top: 0.25rem;
}

.hero-title {
  margin: 0 0 1.25rem;
  font-size: 2.25rem;
  font-weight: 700;
  color: #111;
  letter-spacing: -0.02em;
}

.hero-paragraph {
  margin: 0 0 1rem;
  font-size: 1rem;
  line-height: 1.6;
  color: #333;
}

.text-link {
  color: #0366d6;
  text-decoration: underline;
}

.text-link:hover {
  color: #024ea9;
}

.donate-link {
  display: inline-block;
  margin-top: 1rem;
  color: #0366d6;
  text-decoration: underline;
  font-size: 1rem;
}

.donate-link:hover {
  color: #024ea9;
}

/* Campaigns section */
.campaigns-section {
  margin-top: 3.5rem;
  padding-top: 2.5rem;
  border-top: 1px solid #e5e7eb;
}

.campaigns-heading {
  margin: 0 0 1.75rem;
  font-size: 1.75rem;
  font-weight: 700;
  letter-spacing: -0.02em;
  border-bottom: 2px solid #e5e7eb;
  padding-bottom: 0.5rem;
  display: inline-block;
}

.campaigns-heading-main {
  color: #222;
}

.campaigns-heading-accent {
  color: #0366d6;
  margin-left: 0.25rem;
}

.campaigns-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 1.25rem;
}

.campaign-card {
  display: flex;
  flex-direction: column;
  background: #f9fafb;
  border: 1px solid #e5e7eb;
  border-radius: 12px;
  overflow: hidden;
  text-decoration: none;
  color: inherit;
  transition: box-shadow 0.2s ease, border-color 0.2s ease;
}

.campaign-card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  border-color: #0366d6;
}

.campaign-card-visual {
  height: 100px;
  background: linear-gradient(135deg, #eef2f7 0%, #e5e7eb 100%);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 0.5rem;
}

.campaign-card-logo {
  max-width: 100%;
  max-height: 100%;
  width: auto;
  height: auto;
  object-fit: contain;
}

.campaign-card-visual--monuments { background: linear-gradient(135deg, #fef3f2 0%, #e5e7eb 100%); }
.campaign-card-visual--earth { background: linear-gradient(135deg, #ecfdf5 0%, #e5e7eb 100%); }
.campaign-card-visual--folklore { background: linear-gradient(135deg, #f5f3ff 0%, #e5e7eb 100%); }
.campaign-card-visual--science { background: linear-gradient(135deg, #eff6ff 0%, #e5e7eb 100%); }
.campaign-card-visual--public_art { background: linear-gradient(135deg, #fdf4ff 0%, #e5e7eb 100%); }
.campaign-card-visual--africa { background: linear-gradient(135deg, #fffbeb 0%, #e5e7eb 100%); }
.campaign-card-visual--food { background: linear-gradient(135deg, #f0fdf4 0%, #e5e7eb 100%); }

.campaign-card-body {
  padding: 1rem 1.25rem;
  flex: 1;
}

.campaign-card-title {
  margin: 0 0 0.25rem;
  font-size: 1rem;
  font-weight: 600;
  color: #111;
  line-height: 1.3;
}

.campaign-card-subtitle {
  margin: 0;
  font-size: 0.8125rem;
  color: #6b7280;
}

.campaigns-cta-wrap {
  text-align: center;
  margin-top: 2rem;
}

.campaigns-cta {
  display: inline-block;
  padding: 0.75rem 1.75rem;
  background: #0366d6;
  color: #fff;
  font-weight: 600;
  font-size: 0.9375rem;
  text-decoration: none;
  border-radius: 8px;
  transition: background 0.2s ease;
}

.campaigns-cta:hover {
  background: #024ea9;
}

/* Footer */
.site-footer {
  max-width: 1200px;
  margin: 2rem auto 0;
  padding: 1.5rem 2rem;
  border-top: 1px solid #e5e7eb;
  text-align: center;
  font-size: 0.875rem;
  color: #6b7280;
}

.site-footer p {
  margin: 0;
}

@media (max-width: 768px) {
  .site-header {
    padding: 1rem;
  }

  .main-nav {
    gap: 0.75rem;
  }

  .main-content {
    padding: 1.5rem 1rem;
  }

  .hero-grid {
    grid-template-columns: 1fr;
    gap: 1.5rem;
  }

  .hero-image-wrap {
    order: 1;
  }

  .hero-text {
    order: 2;
  }

  .hero-title {
    font-size: 1.75rem;
  }

  .campaigns-section {
    margin-top: 2.5rem;
    padding-top: 2rem;
  }

  .campaigns-heading {
    font-size: 1.5rem;
  }

  .campaigns-grid {
    grid-template-columns: repeat(2, 1fr);
    gap: 1rem;
  }

  .campaign-card-visual {
    height: 80px;
  }

  .campaigns-cta-wrap {
    margin-top: 1.5rem;
  }
}

@media (max-width: 480px) {
  .campaigns-grid {
    grid-template-columns: 1fr;
  }
}
</style>
