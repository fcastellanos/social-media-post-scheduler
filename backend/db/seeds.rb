# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)

# Idempotent seed data for `Post` records.
# Running `bin/rails db:seed` multiple times will not create duplicates.

example_posts = [
  { 
    title: "Morning motivator", 
    content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
    scheduled_date: Time.current.beginning_of_day + 1.day,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1569021998346-5762c8a548fa", caption: "Photo for Morning Motivator" }
    ]
  },
  { 
    title: "Lunch reminder", 
    content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
    scheduled_date: Time.current.beginning_of_day + 2.days + 12.hours,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1543353071-873f17a7a088", caption: "Photo for Lunch Reminder" },
      { url: "https://images.unsplash.com/photo-1576867757603-05b134ebc379", caption: "Additional photo for Lunch Reminder" }
    ]
  },
  { 
    title: "Afternoon update", 
    content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
    scheduled_date: Time.current.beginning_of_day + 3.days + 15.hours,
    photos_attributes: [
      { url: "https://plus.unsplash.com/premium_photo-1682436366291-6b991f5ca5a2", caption: "Photo for Afternoon Update" }
    ]
  },
  { 
    title: "Evening reflection", 
    content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
    scheduled_date: Time.current.beginning_of_day + 4.days + 18.hours,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1505260540486-10233d451528", caption: "Photo for Evening Reflection" }
    ]
  },
  { 
    title: "Weekend preview", 
    content: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", 
    scheduled_date: Time.current.beginning_of_day + 6.days + 10.hours,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1593653147891-c89068201ed4", caption: "Photo for Weekend Preview" }
    ]
  }
]

example_posts.each do |attrs|
  post = Post.find_or_create_by(title: attrs[:title]) do |p|
		p.content = attrs[:content]
		p.scheduled_date = attrs[:scheduled_date]
	end

  if attrs[:photos_attributes]
    attrs[:photos_attributes].each do |photo_attrs|
      post.photos.find_or_create_by(url: photo_attrs[:url]) do |photo|
        photo.caption = photo_attrs[:caption]
      end
    end
  end
end
