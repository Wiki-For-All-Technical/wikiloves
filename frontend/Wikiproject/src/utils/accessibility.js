// Accessibility utilities

export function announceToScreenReader(message) {
  const announcement = document.createElement('div')
  announcement.setAttribute('role', 'status')
  announcement.setAttribute('aria-live', 'polite')
  announcement.setAttribute('aria-atomic', 'true')
  announcement.className = 'sr-only'
  announcement.textContent = message
  document.body.appendChild(announcement)
  
  setTimeout(() => {
    document.body.removeChild(announcement)
  }, 1000)
}

export function trapFocus(element) {
  const focusableElements = element.querySelectorAll(
    'a[href], button:not([disabled]), textarea:not([disabled]), input:not([disabled]), select:not([disabled]), [tabindex]:not([tabindex="-1"])'
  )
  
  const firstElement = focusableElements[0]
  const lastElement = focusableElements[focusableElements.length - 1]
  
  element.addEventListener('keydown', (e) => {
    if (e.key === 'Tab') {
      if (e.shiftKey) {
        if (document.activeElement === firstElement) {
          lastElement.focus()
          e.preventDefault()
        }
      } else {
        if (document.activeElement === lastElement) {
          firstElement.focus()
          e.preventDefault()
        }
      }
    }
    
    if (e.key === 'Escape') {
      element.dispatchEvent(new CustomEvent('close'))
    }
  })
}

export function setupKeyboardNavigation() {
  // Add keyboard shortcuts
  document.addEventListener('keydown', (e) => {
    // Alt + D: Toggle dark mode
    if (e.altKey && e.key === 'd') {
      e.preventDefault()
      const event = new CustomEvent('toggleTheme')
      window.dispatchEvent(event)
    }
    
    // Alt + S: Focus search
    if (e.altKey && e.key === 's') {
      e.preventDefault()
      const searchInput = document.querySelector('input[type="search"], .search-input')
      if (searchInput) {
        searchInput.focus()
      }
    }
  })
}

