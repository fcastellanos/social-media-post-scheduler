class PropertyDescriptionUpdaterService
  def initialize(limit: nil, sleep_seconds: 0)
    @limit = limit
    @sleep_seconds = sleep_seconds
  end

  # Iterates properties that have no description and attempts to generate
  # and persist a description using OpenaiPropertyDescriptionService.
  # Returns the number of properties updated.
  def call
    scope = Property.where("description IS NULL OR description = ''")

    updated = 0

    if @limit
      scope.limit(@limit).each do |property|
        updated += process_property(property)
      end
    else
      scope.find_each do |property|
        updated += process_property(property)
      end
    end

    updated
  rescue StandardError => e
    Rails.logger.error("PropertyDescriptionUpdaterService error: #{e.message}")
    raise
  end

  private

  def process_property(property)
    description = OpenaiPropertyDescriptionService.new(property).generate_description

    if description.present?
      if property.update(description: description)
        Rails.logger.info("PropertyDescriptionUpdaterService: updated property ##{property.id}")
        1
      else
        Rails.logger.warn("PropertyDescriptionUpdaterService: failed to save property ##{property.id} - #{property.errors.full_messages.join(', ')}")
        0
      end
    else
      Rails.logger.warn("PropertyDescriptionUpdaterService: no description generated for property ##{property.id}")
      0
    end
  ensure
    sleep @sleep_seconds if @sleep_seconds.to_f > 0
  end
end
