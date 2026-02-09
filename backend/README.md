# Backend (Rails API)

Minimal instructions to get the Rails API running locally.

Prerequisites

- Ruby (3.2.x recommended)
- Bundler
- SQLite (development)

Quick start

```bash
# from repository root
cd backend
bundle install
bin/rails db:create db:migrate db:seed
bin/rails server -p 3000
```

The API will be available at `http://localhost:3000` (example: `GET /posts`).
