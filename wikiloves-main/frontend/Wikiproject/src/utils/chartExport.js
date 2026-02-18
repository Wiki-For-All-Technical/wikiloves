export function exportChartAsImage(chartElement, filename = 'chart') {
  return new Promise((resolve, reject) => {
    try {
      if (chartElement instanceof SVGElement) {
        // For SVG elements
        const svgData = new XMLSerializer().serializeToString(chartElement)
        const svgBlob = new Blob([svgData], { type: 'image/svg+xml;charset=utf-8' })
        const svgUrl = URL.createObjectURL(svgBlob)
        
        const img = new Image()
        img.onload = () => {
          const canvas = document.createElement('canvas')
          canvas.width = img.width
          canvas.height = img.height
          const ctx = canvas.getContext('2d')
          ctx.fillStyle = 'white'
          ctx.fillRect(0, 0, canvas.width, canvas.height)
          ctx.drawImage(img, 0, 0)
          
          canvas.toBlob((blob) => {
            const url = URL.createObjectURL(blob)
            const link = document.createElement('a')
            link.href = url
            link.download = `${filename}.png`
            link.click()
            URL.revokeObjectURL(url)
            URL.revokeObjectURL(svgUrl)
            resolve()
          })
        }
        img.onerror = reject
        img.src = svgUrl
      } else {
        // For canvas or other elements
        html2canvas(chartElement, {
          backgroundColor: '#ffffff',
          scale: 2
        }).then(canvas => {
          canvas.toBlob((blob) => {
            const url = URL.createObjectURL(blob)
            const link = document.createElement('a')
            link.href = url
            link.download = `${filename}.png`
            link.click()
            URL.revokeObjectURL(url)
            resolve()
          })
        }).catch(reject)
      }
    } catch (error) {
      reject(error)
    }
  })
}

