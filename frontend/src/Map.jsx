import { APIProvider, Map as VisMap, Marker, InfoWindow } from '@vis.gl/react-google-maps'
import { useState } from 'react'

import { useEffect, useRef } from 'react'

export default function Map({ center = { lat: 37.7749, lng: -122.4194 }, zoom = 10, markers = [], style = { height: '400px', width: '100%' }, onSelect = null, initialSelectedId = null }) {
  const apiKey = import.meta.env.VITE_GOOGLE_MAPS_API_KEY ||  ''

  if (!apiKey) {
    return (
      <div className="text-sm text-red-600">Missing Google Maps API key. Set `VITE_GOOGLE_MAPS_API_KEY` in your .env.</div>
    )
  }

  const [activeMarker, setActiveMarker] = useState(null)
  const [viewCenter, setViewCenter] = useState(center)
  const [viewZoom, setViewZoom] = useState(zoom)

  const truncate = (text, max = 120) => {
    if (!text) return ''
    return text.length > max ? `${text.slice(0, max - 1)}…` : text
  }

  // compute initial bounds from markers if present
  let initialBounds = null
  if (markers && markers.length > 0) {
    const valid = markers.filter((m) => m && typeof m.lat === 'number' && typeof m.lng === 'number')
    if (valid.length === 1) {
      // single marker: center on it
      center = { lat: valid[0].lat, lng: valid[0].lng }
    } else if (valid.length > 1) {
      let north = -90
      let south = 90
      let east = -180
      let west = 180
      valid.forEach((m) => {
        if (m.lat > north) north = m.lat
        if (m.lat < south) south = m.lat
        if (m.lng > east) east = m.lng
        if (m.lng < west) west = m.lng
      })
      initialBounds = { north, south, east, west }
    }
  }

    // If an initialSelectedId is provided, try to find its marker index and open it.
    // Apply only once per initialSelectedId to avoid overriding user clicks after navigation.
    const initialApplied = useRef(false)

    useEffect(() => {
      // reset applied flag when the requested initialSelectedId changes
      initialApplied.current = false
    }, [initialSelectedId])

    useEffect(() => {
      if (initialApplied.current) return
      if (!initialSelectedId || !Array.isArray(markers) || markers.length === 0) return
      const idx = markers.findIndex((m) => m && m.property && (String(m.property.id) === String(initialSelectedId) || String(m.property_id) === String(initialSelectedId)))
      if (idx >= 0) {
        setActiveMarker(idx)
        if (typeof onSelect === 'function') onSelect(markers[idx])
        // center and zoom into the selected property
        setViewCenter({ lat: markers[idx].lat, lng: markers[idx].lng })
        setViewZoom(18)
        initialApplied.current = true
      }
    }, [initialSelectedId, markers, onSelect])

  return (
    <div style={style}>
      <APIProvider apiKey={apiKey}>
        { /* When deep-linking to a property via initialSelectedId, skip initialBounds so explicit center/zoom apply */ }
        <VisMap center={viewCenter} zoom={viewZoom} initialBounds={initialSelectedId ? null : initialBounds} style={{ height: '100%', width: '100%' }}>
          {markers.map((m, i) => (
            m && typeof m.lat === 'number' && typeof m.lng === 'number' ? (
              <Marker
                key={i}
                position={{ lat: m.lat, lng: m.lng }}
                title={m.name || ''}
                onClick={() => {
                  setActiveMarker(i)
                  if (typeof onSelect === 'function') onSelect(m)
                }}
              />
            ) : null
          ))}

          {activeMarker != null && markers[activeMarker] && (
            <InfoWindow position={{ lat: markers[activeMarker].lat, lng: markers[activeMarker].lng }} onCloseClick={() => setActiveMarker(null)}>
              <div className="max-w-xs">
                <div className="flex items-start justify-between">
                  <div className="text-sm font-medium mr-3">{markers[activeMarker].name}</div>
                </div>
                {markers[activeMarker].description ? (
                  <div className="text-sm text-gray-600 mt-1">{truncate(markers[activeMarker].description, 120)}</div>
                ) : null}
              </div>
            </InfoWindow>
          )}
        </VisMap>
      </APIProvider>
    </div>
  )
}
