/**
 * Process Quarry JSON data for statistics dashboard
 * Input: Quarry JSON format with headers and rows
 * Output: Processed statistics data
 */

/**
 * Parse Quarry JSON data
 * @param {Object} quarryData - Quarry JSON response
 * @returns {Array} Array of processed image records
 */
export function parseQuarryData(quarryData) {
  if (!quarryData || !quarryData.headers || !quarryData.rows) {
    return []
  }

  const headers = quarryData.headers
  const rows = quarryData.rows

  return rows.map(row => {
    const record = {}
    headers.forEach((header, index) => {
      record[header] = row[index]
    })
    return record
  })
}

/**
 * Get daily upload statistics
 * @param {Array} records - Processed image records
 * @returns {Array} Daily stats with date and count
 */
export function getDailyUploads(records) {
  const dailyMap = new Map()

  records.forEach(record => {
    const date = record.imgdate || record.img_timestamp?.substring(0, 8)
    if (!date) return

    // Format: YYYYMMDD -> YYYY-MM-DD
    const formattedDate = `${date.substring(0, 4)}-${date.substring(4, 6)}-${date.substring(6, 8)}`
    
    if (!dailyMap.has(formattedDate)) {
      dailyMap.set(formattedDate, 0)
    }
    dailyMap.set(formattedDate, dailyMap.get(formattedDate) + 1)
  })

  // Convert to array and sort by date
  return Array.from(dailyMap.entries())
    .map(([date, count]) => ({ date, count }))
    .sort((a, b) => a.date.localeCompare(b.date))
}

/**
 * Get user contribution statistics
 * @param {Array} records - Processed image records
 * @returns {Array} User stats with username, uploads, and percentage
 */
export function getUserContributions(records) {
  const userMap = new Map()

  records.forEach(record => {
    const username = record.actor_name || 'Unknown'
    if (!userMap.has(username)) {
      userMap.set(username, 0)
    }
    userMap.set(username, userMap.get(username) + 1)
  })

  const total = records.length
  const userStats = Array.from(userMap.entries())
    .map(([username, uploads]) => ({
      username,
      uploads,
      percentage: total > 0 ? (uploads / total) * 100 : 0
    }))
    .sort((a, b) => b.uploads - a.uploads)

  return userStats
}

/**
 * Get file size distribution
 * @param {Array} records - Processed image records
 * @returns {Array} File size buckets with count
 */
export function getFileSizeDistribution(records) {
  const buckets = [
    { label: '< 500 KB', min: 0, max: 500 * 1024, count: 0 },
    { label: '500 KB - 1 MB', min: 500 * 1024, max: 1024 * 1024, count: 0 },
    { label: '1 MB - 2 MB', min: 1024 * 1024, max: 2 * 1024 * 1024, count: 0 },
    { label: '2 MB - 5 MB', min: 2 * 1024 * 1024, max: 5 * 1024 * 1024, count: 0 },
    { label: '5 MB - 10 MB', min: 5 * 1024 * 1024, max: 10 * 1024 * 1024, count: 0 },
    { label: '> 10 MB', min: 10 * 1024 * 1024, max: Infinity, count: 0 }
  ]

  records.forEach(record => {
    const size = parseInt(record.img_size) || 0
    const bucket = buckets.find(b => size >= b.min && size < b.max)
    if (bucket) {
      bucket.count++
    }
  })

  return buckets.filter(b => b.count > 0)
}

/**
 * Get overall statistics
 * @param {Array} records - Processed image records
 * @returns {Object} Overall stats
 */
export function getOverallStats(records) {
  if (records.length === 0) {
    return {
      totalUploads: 0,
      totalSize: 0,
      averageSize: 0,
      uniqueUsers: 0,
      dateRange: { start: null, end: null }
    }
  }

  const sizes = records.map(r => parseInt(r.img_size) || 0).filter(s => s > 0)
  const users = new Set(records.map(r => r.actor_name).filter(Boolean))
  const dates = records
    .map(r => r.imgdate || r.img_timestamp?.substring(0, 8))
    .filter(Boolean)
    .sort()

  const totalSize = sizes.reduce((sum, s) => sum + s, 0)
  const averageSize = sizes.length > 0 ? totalSize / sizes.length : 0

  return {
    totalUploads: records.length,
    totalSize,
    averageSize,
    uniqueUsers: users.size,
    dateRange: {
      start: dates[0] ? formatDate(dates[0]) : null,
      end: dates[dates.length - 1] ? formatDate(dates[dates.length - 1]) : null
    }
  }
}

/**
 * Format date from YYYYMMDD to readable format
 */
function formatDate(dateStr) {
  if (!dateStr || dateStr.length < 8) return null
  const year = dateStr.substring(0, 4)
  const month = dateStr.substring(4, 6)
  const day = dateStr.substring(6, 8)
  return `${year}-${month}-${day}`
}

/**
 * Format file size to human readable
 */
export function formatFileSize(bytes) {
  if (bytes === 0) return '0 B'
  const k = 1024
  const sizes = ['B', 'KB', 'MB', 'GB']
  const i = Math.floor(Math.log(bytes) / Math.log(k))
  return Math.round((bytes / Math.pow(k, i)) * 100) / 100 + ' ' + sizes[i]
}
