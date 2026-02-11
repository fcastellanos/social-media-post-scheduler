import { useEffect, useState } from 'react'
import axios from 'axios'
import Map from './Map'

export default function Properties() {
  const [properties, setProperties] = useState([])
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
        <h1 className="text-3xl font-extrabold text-gray-900">Properties</h1>
      </header>
      <section className="mb-8">
        <Map markers={properties.map(p => ({ lat: Number(p.latitude), lng: Number(p.longitude), name: p.name }))} />
      </section>
    </div>
  )
}