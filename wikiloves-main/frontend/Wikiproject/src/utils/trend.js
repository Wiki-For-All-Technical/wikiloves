export const buildTrendPoints = (values = [], width = 120, height = 40) => {
  if (!values.length) {
    return ''
  }

  const max = Math.max(...values)
  const min = Math.min(...values)
  const range = max - min || 1
  const step = values.length === 1 ? width : width / (values.length - 1)

  return values
    .map((value, index) => {
      const x = +(index * step).toFixed(2)
      const normalized = (value - min) / range
      const y = +((1 - normalized) * height).toFixed(2)
      return `${x},${y}`
    })
    .join(' ')
}

