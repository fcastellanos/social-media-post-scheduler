import { useEffect, useState } from 'react'
import axios from 'axios'
import Post from './Post'

export default function Posts() {
  const [posts, setPosts] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    setLoading(true)
    setError(null)

    axios
      .get('http://localhost:3000/posts', { withCredentials: true })
      .then((res) => {
        setPosts(res.data)
      })
      .catch((err) => {
        setError(err.message || 'Request failed')
      })
      .finally(() => {
        setLoading(false)
      })
  }, [])

  if (loading)
    return <div className="max-w-3xl mx-auto p-6 text-center">Loading posts…</div>
  if (error)
    return (
      <div className="max-w-3xl mx-auto p-6 text-center text-red-600">Error: {error}</div>
    )

  return (
    <div className="max-w-7xl mx-auto px-6 py-10">
      <header className="mb-8">
        <h1 className="text-3xl font-extrabold text-gray-900">Posts</h1>
      </header>

      {posts.length === 0 ? (
        <div className="text-center text-gray-500">No posts yet.</div>
      ) : (
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">
          {posts.map((p) => (
            <Post key={p.id} post={p} />
          ))}
        </div>
      )}
    </div>
  )
}
