import scienceData from './wiki-science-competition.json'
import folkloreData from './wiki-folklore.json'
import africaData from './wiki-africa.json'
import foodData from './wiki-food.json'
import publicArtData from './wiki-public-art.json'
import earthData from './wiki-earth.json'
import monumentsData from './wiki-monuments.json'

const campaignsBySlug = {
  science: scienceData,
  folklore: folkloreData,
  africa: africaData,
  food: foodData,
  public_art: publicArtData,
  earth: earthData,
  monuments: monumentsData,
}

export function getCampaignData(slug) {
  return campaignsBySlug[slug] ?? null
}

export const campaignSlugs = Object.keys(campaignsBySlug)
