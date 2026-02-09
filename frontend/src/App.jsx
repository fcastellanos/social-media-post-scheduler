import './App.css'
import Posts from './Posts'
import PostView from './PostView'
import { BrowserRouter, Routes, Route } from 'react-router-dom'

function App() {
  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<Posts />} />
        <Route path="/posts/:id" element={<PostView />} />
      </Routes>
    </BrowserRouter>
  )
}

export default App
