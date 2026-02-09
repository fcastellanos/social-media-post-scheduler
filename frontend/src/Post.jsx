import { Link } from 'react-router-dom'

export default function Post({ post }) {
  const title = post.title || 'Untitled'
  const content = post.content ?? ''
  const scheduled = post.scheduled_date || null

  let scheduledLabel = ''
  if (scheduled) {
    try {
      const d = new Date(scheduled)
      if (!isNaN(d)) scheduledLabel = d.toLocaleDateString()
    } catch (e) {
      scheduledLabel = String(scheduled)
    }
  }

  const excerpt = content.length > 120 ? content.slice(0, 120).trim() + '…' : content
  const firstPhoto = post.photos && post.photos.length ? post.photos[0] : null

  return (
    <article className="bg-white rounded-lg shadow-md overflow-hidden">
      {firstPhoto && (
        <div className="w-full">
          <img
            src={firstPhoto.url}
            alt={firstPhoto.caption || title}
            className="w-full h-40 object-cover"
            style={{ borderTopLeftRadius: '0.5rem', borderTopRightRadius: '0.5rem', maxHeight: '220px' }}
          />
        </div>
      )}

      <div className="p-4">
        {scheduledLabel ? (
          <div className="text-sm text-gray-500 mb-2">{scheduledLabel}</div>
        ) : null}

        <h3 className="text-xl font-bold mb-2 leading-tight">
          <Link to={`/posts/${post.id}`} className="text-gray-900 hover:underline">{title}</Link>
        </h3>

        <p className="text-sm text-gray-600">{excerpt}</p>
      </div>
    </article>
  )
}
