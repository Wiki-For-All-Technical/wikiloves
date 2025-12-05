<script setup>
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useToast } from '@/composables/useToast'

const props = defineProps({
  title: {
    type: String,
    default: 'Wiki Loves Competitions'
  },
  text: {
    type: String,
    default: 'Check out these statistics!'
  }
})

const route = useRoute()
const toast = useToast()

const shareUrl = computed(() => {
  return window.location.href
})

const copyToClipboard = async () => {
  try {
    await navigator.clipboard.writeText(shareUrl.value)
    toast.success('Link copied to clipboard!')
  } catch (err) {
    toast.error('Failed to copy link')
    console.error('Failed to copy:', err)
  }
}

const shareNative = async () => {
  if (navigator.share) {
    try {
      await navigator.share({
        title: props.title,
        text: props.text,
        url: shareUrl.value
      })
      toast.success('Shared successfully!')
    } catch (err) {
      if (err.name !== 'AbortError') {
        toast.error('Failed to share')
      }
    }
  } else {
    copyToClipboard()
  }
}

const shareTwitter = () => {
  const url = `https://twitter.com/intent/tweet?text=${encodeURIComponent(props.text)}&url=${encodeURIComponent(shareUrl.value)}`
  window.open(url, '_blank', 'width=550,height=420')
  toast.info('Opening Twitter...')
}

const shareFacebook = () => {
  const url = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(shareUrl.value)}`
  window.open(url, '_blank', 'width=550,height=420')
  toast.info('Opening Facebook...')
}
</script>

<template>
  <div class="share-menu">
    <button @click="shareNative" class="share-button" title="Share">
      <span class="share-icon">🔗</span>
      <span class="share-text">Share</span>
    </button>
    <div class="share-dropdown">
      <button @click="copyToClipboard" class="share-option">
        <span>📋</span> Copy Link
      </button>
      <button @click="shareTwitter" class="share-option">
        <span>🐦</span> Twitter
      </button>
      <button @click="shareFacebook" class="share-option">
        <span>📘</span> Facebook
      </button>
    </div>
  </div>
</template>

<style scoped>
.share-menu {
  position: relative;
  display: inline-block;
}

.share-button {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.625rem 1rem;
  background: var(--accent-color, #1f8a70);
  color: #ffffff;
  border: none;
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.share-button:hover {
  background: var(--accent-hover, #1a6b57);
  transform: translateY(-1px);
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
}

.share-icon {
  font-size: 1rem;
}

.share-dropdown {
  position: absolute;
  top: 100%;
  right: 0;
  margin-top: 0.5rem;
  background: var(--bg-card, #ffffff);
  border: 1px solid var(--border-color, #e5e7eb);
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  min-width: 160px;
  opacity: 0;
  visibility: hidden;
  transform: translateY(-10px);
  transition: all 0.2s ease;
  z-index: 1000;
}

.share-menu:hover .share-dropdown {
  opacity: 1;
  visibility: visible;
  transform: translateY(0);
}

.share-option {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  width: 100%;
  padding: 0.75rem 1rem;
  background: transparent;
  border: none;
  text-align: left;
  font-size: 0.875rem;
  color: var(--text-primary, #111827);
  cursor: pointer;
  transition: background 0.2s ease;
}

.share-option:first-child {
  border-radius: 8px 8px 0 0;
}

.share-option:last-child {
  border-radius: 0 0 8px 8px;
}

.share-option:hover {
  background: var(--bg-hover, #f3f4f6);
}

.share-option span {
  font-size: 1rem;
}
</style>

