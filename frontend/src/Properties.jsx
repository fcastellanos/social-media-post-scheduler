import { useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import axios from 'axios'
import Map from './Map'
import Property from './Property'

export default function Properties() {
  const [properties, setProperties] = useState([])
  const [selectedProperty, setSelectedProperty] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  
  useEffect(() => {
    setLoading(true)
    setError(null)
    
    axios
      .get('http://localhost:3000/properties', { withCredentials: true })
      .then((res) => {
        setProperties(res.data || [])
      })
      .catch((err) => {
        setError(err.message || 'Request failed')
      })
      .finally(() => {
        setLoading(false)
      })
    }, []
  )
  
  if (loading)
    return <div className="max-w-3xl mx-auto p-6 text-center">Loading properties…</div>
  if (error)
    return <div className="max-w-3xl mx-auto p-6 text-center text-red-600">Error: {error}</div>

  return (
    <div className="max-w-7xl mx-auto px-6 py-10">
      <header className="mb-8">
        <div className="flex items-center justify-between">
          <h1 className="text-3xl font-extrabold text-gray-900">Properties</h1>
          <Link to="/" className="inline-flex items-center gap-2 px-3 py-2 bg-gray-100 text-gray-800 rounded">
            Posts
          </Link>
        </div>
      </header>
      <section className="mb-8">
        <Map
          markers={properties.map(p => ({ lat: Number(p.latitude), lng: Number(p.longitude), name: p.name, description: p.description, property: p }))}
          onSelect={(item) => setSelectedProperty(item && item.property ? item.property : item)}
        />
      </section>

      {selectedProperty ? (
        <section className="bg-white rounded shadow p-6 mt-6">
          <Property property={selectedProperty} />
        </section>
      ) : null}
    </div>
  )
}