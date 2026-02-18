import { describe, expect, it } from 'vitest'
import { buildTrendPoints } from '../trend'

describe('buildTrendPoints', () => {
  it('normalizes values between 0 and provided height', () => {
    const result = buildTrendPoints([10, 20, 30], 120, 40)
    expect(result).toContain('0,40')
    expect(result).toContain('120,0')
  })

  it('handles flat series gracefully', () => {
    const result = buildTrendPoints([5, 5, 5])
    expect(result.split(' ').every((point) => point.endsWith(',40'))).toBe(true)
  })

  it('returns empty string for missing values', () => {
    expect(buildTrendPoints([])).toBe('')
  })
})

