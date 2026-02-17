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

        <h3 className="text-xl font-bold mb-2 leading-tight flex items-center gap-3">
          <Link to={`/posts/${post.id}`} className="text-gray-900 hover:underline flex-1">{title}</Link>
          {post.property_id ? (
            <span title={post.property.name || 'Linked property'} className="inline-flex items-center gap-2 text-sm text-white bg-green-600 px-2 py-1 rounded">
              <svg xmlns="http://www.w3.org/2000/svg" className="h-4 w-4" viewBox="0 0 20 20" fill="currentColor">
                <path d="M10 2a6 6 0 00-6 6c0 5 6 10 6 10s6-5 6-10a6 6 0 00-6-6zm0 8a2 2 0 110-4 2 2 0 010 4z" />
              </svg>
              <span className="font-medium">Property</span>
            </span>
          ) : null}
        </h3>

        <p className="text-sm text-gray-600">{excerpt}</p>
      </div>
    </article>
  )
}
