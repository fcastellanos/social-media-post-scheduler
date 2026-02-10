import { useState } from 'react'
import { useNavigate } from 'react-router-dom'
import axios from 'axios'

export default function DeleteButton({ postId, onDeleted }) {
  const navigate = useNavigate()
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const handleDelete = async () => {
    if (!confirm('Are you sure you want to delete this post? This cannot be undone.')) return
    setLoading(true)
    setError(null)
    try {
      await axios.delete(`http://localhost:3000/posts/${postId}`, { withCredentials: true })
      onDeleted && onDeleted()
      navigate('/')
    } catch (err) {
      setError(err.response?.data?.error || err.message || 'Delete failed')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="flex items-center gap-2">
      {error && <div className="text-sm text-red-600">{error}</div>}
      <button onClick={handleDelete} disabled={loading} className="text-sm px-3 py-1 rounded bg-red-600 text-white">
        {loading ? 'Deleting…' : 'Delete'}
      </button>
    </div>
  )
}
