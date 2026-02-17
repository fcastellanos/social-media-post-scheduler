require 'json'
require 'time'

class OpenaiPropertyPostGeneratorService
  def initialize(property, num_posts: 1)
    @property = property
    @num_posts = num_posts.to_i > 0 ? num_posts.to_i : 1
  end

  # Returns an array of post-like hashes similar to example_posts in seeds.rb:
  # [ { title: ..., content: ..., scheduled_date: ..., property_id: ..., photos_attributes: [ { url: ..., caption: ... } ] }, ... ]
  def generate_posts
    api_key = ENV['OPENAI_API_KEY']
    if api_key.nil? || api_key.empty?
      Rails.logger.warn("OPENAI_API_KEY not set; skipping OpenAI post generation")
      return []
    end

    client = OpenAI::Client.new(api_key: api_key)

    prompt = build_prompt

    begin
      resp = client.chat.completions.create(
        messages: [{ role: 'user', content: prompt }],
        model: 'gpt-5.2'
      )

      text = resp&.choices&.first&.message&.content
      return [] unless text && text.strip.length > 0

      json_text = extract_json_array(text)
      posts = JSON.parse(json_text)

      return posts.is_a?(Array) ? posts : []
    rescue JSON::ParserError => e
      Rails.logger.error("OpenAI post generator JSON parse error: #{e.message}")
      []
    rescue StandardError => e
      Rails.logger.error("OpenAI post generator error: #{e.message}")
      []
    end
  end

  private

  def build_prompt
    details = []
    details << "Name: #{@property.name}" if @property.respond_to?(:name)
    details << "Address: #{@property.address}" if @property.respond_to?(:address)
    details << "City: #{@property.city}" if @property.respond_to?(:city)
    details << "State: #{@property.state}" if @property.respond_to?(:state)
    details << "Zip: #{@property.zip}" if @property.respond_to?(:zip)
    details << "Description: #{@property.description}" if @property.respond_to?(:description) && @property.description.present?

    <<~PROMPT
      You are a helpful assistant that writes short social media posts for real estate properties.
      Given the following property details:
      #{details.join("\n")}

      Produce #{@num_posts} social media post(s) as a JSON array. Each array element must be an object with the following keys:
      - title: a short attention-grabbing title (string)
      - content: the post content (string), highlight the surrounding area and nearby amenities, keep it concise (~1-3 short paragraphs)
      - scheduled_date: either an ISO 8601 datetime string or null (you may set null)
      - property_id: #{@property.id} (integer)
      - photos_attributes: an array (possibly empty) of objects with keys `url` and `caption`. If you include an image, prefer an Unsplash public image URL.

      Respond with JSON only (no extra commentary). Ensure the output is valid JSON.
    PROMPT
  end

  # Attempts to extract the first JSON array blob from the model output
  def extract_json_array(text)
    start_idx = text.index('[')
    end_idx = text.rindex(']')
    if start_idx && end_idx && end_idx > start_idx
      text[start_idx..end_idx]
    else
      text
    end
  end
end
