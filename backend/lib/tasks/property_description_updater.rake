namespace :property do
  desc "Generate descriptions for properties missing them. Options: LIMIT, SLEEP_SECONDS, DRY_RUN"
  task generate_descriptions: :environment do
    limit = ENV['LIMIT']&.to_i
    sleep_seconds = ENV['SLEEP_SECONDS'] ? ENV['SLEEP_SECONDS'].to_f : 0
    dry_run = ENV['DRY_RUN'] == 'true'

    puts "Finding properties without descriptions..."

    if dry_run
      count = Property.where("description IS NULL OR description = ''").count
      puts "Dry run: #{count} properties would be processed."
      next
    end

    updater = PropertyDescriptionUpdaterService.new(limit: limit, sleep_seconds: sleep_seconds)
    updated = updater.call

    puts "Updated #{updated} properties."
  end
end
