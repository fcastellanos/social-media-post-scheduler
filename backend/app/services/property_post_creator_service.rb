require 'time'

class PropertyPostCreatorService
  def initialize(posts_array)
    @posts = posts_array || []
  end

  # Creates posts and associated photos. Returns an array of created/updated Post records.
  def call
    created_records = []

    ActiveRecord::Base.transaction do
      @posts.each do |attrs|
        title = attrs['title'] || attrs[:title]
        next unless title && title.strip.length > 0

        post = Post.find_or_initialize_by(title: title)
        post.content = attrs['content'] || attrs[:content]

        scheduled_val = attrs['scheduled_date'] || attrs[:scheduled_date]
        if scheduled_val && scheduled_val.to_s.strip.length > 0
          begin
            post.scheduled_date = Time.parse(scheduled_val.to_s)
          rescue StandardError
            post.scheduled_date = scheduled_val
          end
        end

        post.save!

        photos = attrs['photos_attributes'] || attrs[:photos_attributes] || []
        photos.each do |pattrs|
          url = pattrs['url'] || pattrs[:url]
          next unless url && url.strip.length > 0
          photo = post.photos.find_or_initialize_by(url: url)
          photo.caption = pattrs['caption'] || pattrs[:caption]
          photo.save! if photo.new_record? || photo.changed?
        end

        created_records << post
      end
    end

    created_records
  rescue StandardError => e
    Rails.logger.error("PropertyPostCreatorService error: #{e.message}")
    raise
  end
end
