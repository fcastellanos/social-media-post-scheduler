import { useState } from 'react'
import axios from 'axios'

export default function ScheduledPostForm({ onCancel, onCreated }) {
  const [title, setTitle] = useState('')
  const [content, setContent] = useState('')
  const [scheduledDate, setScheduledDate] = useState('')
  const [photoUrl, setPhotoUrl] = useState('')
  const [photoCaption, setPhotoCaption] = useState('')
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState(null)

  const submit = async (e) => {
    e.preventDefault()
    setLoading(true)
    setError(null)

    // Client-side validation: scheduled date must not be in the past
    if (scheduledDate) {
      try {
        const inputTime = new Date(scheduledDate).getTime()
        if (!isNaN(inputTime) && inputTime < Date.now()) {
          setError('Scheduled date cannot be in the past')
          setLoading(false)
          return
        }
      } catch (e) {
        // ignore and rely on server validation
      }
    }

    const payload = {
      post: {
        title,
        content,
        scheduled_date: scheduledDate,
        photos_attributes: photoUrl ? [{ url: photoUrl, caption: photoCaption }] : []
      }
    }

    try {
      const res = await axios.post('http://localhost:3000/posts', payload, { withCredentials: true })
      onCreated && onCreated(res.data)
    } catch (err) {
      setError(err.response?.data?.errors?.join(', ') || err.message || 'Request failed')
    } finally {
      setLoading(false)
    }
  }

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40">
      <form onSubmit={submit} className="bg-white rounded-lg shadow-lg p-6 w-full max-w-lg">
        <h2 className="text-xl font-bold mb-4">New Scheduled Post</h2>

        {error && <div className="text-sm text-red-600 mb-2">{error}</div>}

        <label className="block mb-2">
          <span className="text-sm font-medium text-gray-700">Title</span>
          <input value={title} onChange={(e) => setTitle(e.target.value)} className="mt-1 block w-full rounded border-gray-200 shadow-sm p-2" required />
        </label>

        <label className="block mb-2">
          <span className="text-sm font-medium text-gray-700">Content</span>
          <textarea value={content} onChange={(e) => setContent(e.target.value)} rows={4} className="mt-1 block w-full rounded border-gray-200 shadow-sm p-2" required />
        </label>

        <label className="block mb-2">
          <span className="text-sm font-medium text-gray-700">Scheduled Date</span>
          <input type="datetime-local" value={scheduledDate} onChange={(e) => setScheduledDate(e.target.value)} className="mt-1 block w-full rounded border-gray-200 shadow-sm p-2" required />
        </label>

        <label className="block mb-2">
          <span className="text-sm font-medium text-gray-700">Photo URL (optional)</span>
          <input value={photoUrl} onChange={(e) => setPhotoUrl(e.target.value)} className="mt-1 block w-full rounded border-gray-200 shadow-sm p-2" />
        </label>

        <label className="block mb-4">
          <span className="text-sm font-medium text-gray-700">Photo caption (optional)</span>
          <input value={photoCaption} onChange={(e) => setPhotoCaption(e.target.value)} className="mt-1 block w-full rounded border-gray-200 shadow-sm p-2" />
        </label>

        <div className="flex items-center justify-end gap-3">
          <button type="button" onClick={onCancel} className="px-4 py-2 rounded bg-gray-200 text-gray-700">Cancel</button>
          <button type="submit" disabled={loading} className="px-4 py-2 rounded bg-blue-600 text-white">
            {loading ? 'Saving…' : 'Schedule Post'}
          </button>
        </div>
      </form>
    </div>
  )
}
