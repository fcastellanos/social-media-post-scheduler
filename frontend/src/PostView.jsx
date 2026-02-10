import { useEffect, useState } from 'react'
import axios from 'axios'
import { useParams, Link } from 'react-router-dom'
import DeleteButton from './DeleteButton'

export default function PostView() {
  const { id } = useParams()
  const [post, setPost] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    if (!id) return
    setLoading(true)
    setError(null)

    axios
      .get(`http://localhost:3000/posts/${id}`, { withCredentials: true })
      .then((res) => setPost(res.data))
      .catch((err) => setError(err.message || 'Request failed'))
      .finally(() => setLoading(false))
  }, [id])

  if (loading) return <div className="max-w-3xl mx-auto p-6 text-center">Loading…</div>
  if (error) return <div className="max-w-3xl mx-auto p-6 text-center text-red-600">Error: {error}</div>
  if (!post) return <div className="max-w-3xl mx-auto p-6 text-center">Post not found.</div>

  return (
    <div className="max-w-2xl mx-auto px-4 py-8">
      <div className="mb-4">
        <div className="flex items-center justify-between">
          <Link to="/" className="text-sm text-gray-600 hover:underline">← Back</Link>
          <DeleteButton postId={post.id} />
        </div>
      </div>

      <article className="bg-white border border-gray-100 rounded-lg shadow-sm p-6">
        <h1 className="text-2xl font-semibold text-gray-900 mb-2">{post.title}</h1>
        {post.scheduled_date ? (
          <div className="text-sm text-gray-500 mb-4">Scheduled: {new Date(post.scheduled_date).toLocaleString()}</div>
        ) : null}

        {post.photos && post.photos.length > 0 && (
          <div className="mb-6">
            {post.photos.map((photo) => (
              <figure key={photo.id} className="mb-4">
                <img
                  src={photo.url}
                  alt={photo.caption || post.title}
                  className="w-full h-48 md:h-64 object-cover rounded-lg shadow-md mx-auto"
                  style={{ maxWidth: '800px', width: '100%', height: 'auto', display: 'block' }}
                />
                {photo.caption ? (
                  <figcaption className="mt-2 text-sm text-gray-600">{photo.caption}</figcaption>
                ) : null}
              </figure>
            ))}
          </div>
        )}

        <div className="prose max-w-none text-gray-800 whitespace-pre-wrap">{post.content}</div>
      </article>
    </div>
  )
}
