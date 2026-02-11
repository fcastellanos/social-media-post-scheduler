class OpenaiPropertyDescriptionService  
  def initialize(property)
    @property = property
  end

  def generate_description
    prompt = "Write a compelling description for a property with the following details:\n" \
             "Address: #{@property.address}\n" \
             "City: #{@property.city}\n" \
             "State: #{@property.state}\n" \
             "Zip: #{@property.zip}\n" \
             "Description:"

    api_key = ENV['OPENAI_API_KEY']

    if api_key.nil? || api_key.empty?
      Rails.logger.warn("OPENAI_API_KEY not set; skipping OpenAI description generation")
      return ""
    end

    openai_client = OpenAI::Client.new(api_key: api_key)

    begin
      chat_completion = openai_client.chat.completions.create(
        messages: [{role: "user", content: prompt}],
        model: "gpt-5.2"
      )

      return "" unless chat_completion&.choices&.first&.message&.content

      chat_completion.choices.first.message.content.strip
    rescue StandardError => e
      Rails.logger.error("OpenAI API error: #{e.message}")
      ""
    end
  end
end