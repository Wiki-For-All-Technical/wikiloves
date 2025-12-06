<script setup>
const printPage = () => {
  window.print()
}
</script>

<template>
  <button @click="printPage" class="print-button" title="Print page">
    <span class="print-icon">🖨️</span>
    <span class="print-text">Print</span>
  </button>
</template>

<style scoped>
.print-button {
  display: inline-flex;
  align-items: center;
  gap: 0.5rem;
  padding: 0.625rem 1rem;
  background: var(--bg-card, #ffffff);
  color: var(--text-primary, #111827);
  border: 2px solid var(--border-color, #e5e7eb);
  border-radius: 8px;
  font-size: 0.875rem;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.2s ease;
}

.print-button:hover {
  background: var(--bg-hover, #f3f4f6);
  border-color: var(--accent-color, #1f8a70);
  color: var(--accent-color, #1f8a70);
}

.print-icon {
  font-size: 1rem;
}

@media print {
  .print-button {
    display: none;
  }
}
</style>

