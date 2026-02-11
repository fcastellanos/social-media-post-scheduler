import React from 'react'

export default function Property({ property }) {
  if (!property) return null

  const address = [property.address, property.city, property.state, property.zip].filter(Boolean).join(', ')

  return (
    <div>
      <h2 className="text-2xl font-bold mb-2">{property.name || property.title || 'Property'}</h2>
      {address ? <div className="text-sm text-gray-600 mb-3">{address}</div> : null}
      {property.description ? (
        <div className="text-gray-700 whitespace-pre-line">{property.description}</div>
      ) : (
        <div className="text-sm text-gray-500">No description available.</div>
      )}
    </div>
  )
}
