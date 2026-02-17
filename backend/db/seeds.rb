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

properties = [
  { name: "Maple Ridge Flats", address: "1842 W Juniper Crest Ave", city: "Northlake Heights", state: "IL", zip: "60618", latitude: 41.954812, longitude: -87.691443 },
  { name: "Juniper Court Apartments", address: "1935 W Pine Hollow St", city: "Northlake Heights", state: "IL", zip: "60618", latitude: 41.951376, longitude: -87.684920 },
  { name: "The Willowline", address: "2108 N Cedarbank Blvd", city: "Northlake Heights", state: "IL", zip: "60618", latitude: 41.958225, longitude: -87.676517 },
  { name: "Lakeview Terrace Homes", address: "722 E Ashford Ln", city: "Northlake Heights", state: "IL", zip: "60618", latitude: 41.946903, longitude: -87.667284 },
  { name: "Crestwood Lofts", address: "1601 N Briarstone Rd", city: "Northlake Heights", state: "IL", zip: "60618", latitude: 41.962488, longitude: -87.661901 },
  { name: "Harbor Point Residences", address: "905 W Silverleaf Dr", city: "Northlake Heights", state: "IL", zip: "60618", latitude: 41.944117, longitude: -87.655632 },
  { name: "Fulton Grove Apartments", address: "2480 N Meadowrun Ct", city: "Northlake Heights", state: "IL", zip: "60618", latitude: 41.969054, longitude: -87.649875 },
  { name: "The Alderstone", address: "1317 W Oakrun Ave", city: "Northlake Heights", state: "IL", zip: "60618", latitude: 41.957041, longitude: -87.647112 },
  { name: "Gaslamp Lofts", address: "456 5th Ave", city: "San Diego", state: "CA", zip: "92101", latitude: 32.7138, longitude: -117.1600 },
  { name: "La Jolla Cove Apartments", address: "120 Prospect St", city: "La Jolla", state: "CA", zip: "92037", latitude: 32.8328, longitude: -117.2713 },
  { name: "Pacific Beach Residences", address: "789 Mission Blvd", city: "San Diego", state: "CA", zip: "92109", latitude: 32.7909, longitude: -117.2520 },
  { name: "Ocean Beach Villas", address: "1020 Cable St", city: "San Diego", state: "CA", zip: "92107", latitude: 32.7503, longitude: -117.2500 },
  { name: "North Park Commons", address: "3030 30th St", city: "San Diego", state: "CA", zip: "92104", latitude: 32.7348, longitude: -117.1297 },
  { name: "Hillcrest Gardens", address: "402 University Ave", city: "San Diego", state: "CA", zip: "92103", latitude: 32.7488, longitude: -117.1659 },
  { name: "Mission Valley Place", address: "210 Rio Vista St", city: "San Diego", state: "CA", zip: "92108", latitude: 32.7638, longitude: -117.1236 },
  { name: "Coronado Bay Residences", address: "101 Orange Ave", city: "Coronado", state: "CA", zip: "92118", latitude: 32.6849, longitude: -117.1831 },
  { name: "Little Italy Flats", address: "225 India St", city: "San Diego", state: "CA", zip: "92101", latitude: 32.7229, longitude: -117.1695 },
  { name: "Point Loma Harbor Homes", address: "1601 Rosecrans St", city: "San Diego", state: "CA", zip: "92106", latitude: 32.6748, longitude: -117.2390 }
]

properties.each do |attrs|
  p = Property.find_or_initialize_by(name: attrs[:name], address: attrs[:address])
  p.city = attrs[:city]
  p.state = attrs[:state]
  p.zip = attrs[:zip]
  p.latitude = attrs[:latitude]
  p.longitude = attrs[:longitude]
  p.save! if p.new_record? || p.changed?
end

example_posts = [
  {
    title: "Northlake Heights Charm + Convenience",
    content: "Discover Maple Ridge Flats at 1842 W Juniper Crest Ave—an inviting home with a comfortable, light-filled layout and a warm, welcoming feel.\n\nEnjoy a peaceful residential setting while staying close to Northlake Heights parks, local dining, shopping, and convenient commuter routes. Schedule your showing and see this neighborhood gem in person.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Maple Ridge Flats")&.id,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1568605114967-8130f3a36994?auto=format&fit=crop&w=1600&q=80", caption: "Classic curb appeal in a welcoming neighborhood setting." }
    ]
  },
  {
    title: "Quiet Street, City Convenience",
    content: "Discover Juniper Court Apartments at 1935 W Pine Hollow St in Northlake Heights (60618)—tucked on a calm residential block with a welcoming neighborhood feel.\n\nEnjoy nearby parks, local dining, and everyday essentials just minutes away, plus easy access to major routes and public transit for a smooth commute around Chicago. Schedule a showing and see it for yourself.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Juniper Court Apartments")&.id,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=1600&q=80", caption: "Bright, comfortable apartment living in a convenient neighborhood setting." }
    ]
  },
  {
    title: "Boulevard Living in Northlake Heights",
    content: "Meet The Willowline at 2108 N Cedarbank Blvd—set on a charming boulevard in Northlake Heights (60618), where classic neighborhood vibes meet everyday convenience.\n\nEnjoy quick access to local parks, dining, shopping, and commuter routes—perfect for relaxed weeknights at home or easy weekends out. Come see the possibilities in a location that feels connected, yet comfortably removed.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "The Willowline")&.id,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1578423512979-4c2ef54000a0?auto=format&fit=crop&w=1600&q=80", caption: "Welcome home to boulevard living at The Willowline in Northlake Heights." }
    ]
  },
  {
    title: "Quiet Street, City Convenience in 60618",
    content: "Welcome to Lakeview Terrace Homes at 722 E Ashford Ln in Northlake Heights—set on a calm, neighbor-friendly street with the comfort of a true residential enclave.\n\nEnjoy easy access to local dining, shopping, parks, and convenient commuting options—all while coming home to a peaceful Chicago 60618 address with long-term appeal. Schedule a visit and see it in person!",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Lakeview Terrace Homes")&.id,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1654346714043-1e3c41a96611?auto=format&fit=crop&w=1600&q=80", caption: "A welcoming neighborhood feel with city convenience nearby." }
    ]
  },
  {
    title: "Northlake Heights Convenience, 60618 Charm",
    content: "Discover Crestwood Lofts at 1601 N Briarstone Rd—set in a quiet, tree-lined Northlake Heights neighborhood with the everyday perks you want close by.\n\nEnjoy quick access to local dining, shopping, parks, and easy commuter routes—perfect for putting down roots or investing in a sought-after 60618 pocket. Schedule a showing and experience the area for yourself.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Crestwood Lofts")&.id,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=1600&q=80", caption: "A welcoming neighborhood vibe with convenient city access." }
    ]
  },
  {
    title: "Quiet Street, City-Close Living in 60618",
    content: "Welcome to Harbor Point Residences at 905 W Silverleaf Dr—tucked on a peaceful residential street in Northlake Heights. Enjoy the best of both worlds: a calm, private setting with quick access to neighborhood dining, parks, and everyday conveniences.\n\nStep inside to a bright, functional layout made for easy living—whether you’re hosting friends or settling in for a cozy night at home. Close to commuter routes and local favorites, this 60618 gem is ready to be your next address.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Harbor Point Residences")&.id,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1675706040633-72f5c11511e2?auto=format&fit=crop&w=1600&q=80", caption: "Harbor Point Residences — inviting curb appeal on a quiet neighborhood street." }
    ]
  },
  {
    title: "Quiet Cul-de-Sac Living in Northlake Heights",
    content: "Welcome to Fulton Grove Apartments at 2480 N Meadowrun Ct—tucked on a peaceful cul-de-sac in sought-after Northlake Heights (60618). Enjoy a bright, comfortable layout with an easy flow for relaxing, entertaining, or working from home.\n\nStep outside for calm morning walks and easy access to nearby parks, dining, shopping, and commuter routes—everything you need, right where you want to be.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Fulton Grove Apartments")&.id,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1605664819150-0983c7b4a537?auto=format&fit=crop&w=1600&q=80", caption: "Light-filled living spaces in a quiet Northlake Heights setting." }
    ]
  },
  {
    title: "Northlake Heights Living at The Alderstone",
    content: "Welcome to The Alderstone at 1317 W Oakrun Ave—set in the heart of Northlake Heights (60618), where neighborhood charm meets everyday convenience.\n\nEnjoy walkable streets and easy access to parks, cafes, dining, and shopping, plus great connectivity to major routes and transit for a smooth commute downtown or around Chicago. A prime address in a community you’ll love coming home to.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "The Alderstone")&.id,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1752874854025-fdac29325a6e?auto=format&fit=crop&w=1600&q=80", caption: "Neighborhood charm and city convenience in Northlake Heights." }
    ]
  },
  {
    title: "Downtown San Diego at Your Doorstep",
    content: "Welcome to Gaslamp Lofts at 456 5th Ave—right in the heart of downtown San Diego. Step outside to the best of the Gaslamp Quarter’s dining, nightlife, and culture.\n\nCatch a game at Petco Park, stroll to waterfront attractions, and enjoy easy access to major commuter routes—all with the unbeatable energy of a truly walkable neighborhood.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Gaslamp Lofts")&.id,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1583133010806-4368fdcb29e0?auto=format&fit=crop&w=1600&q=80", caption: "Downtown San Diego vibes near the Gaslamp Quarter" }
    ]
  },
  {
    title: "Live Steps from La Jolla Cove",
    content: "Coastal living doesn’t get more iconic than La Jolla Village. La Jolla Cove Apartments at 120 Prospect St places you moments from the shoreline—think ocean breezes, sunrise walks to the water, and sunset strolls through town.\n\nEnjoy easy access to La Jolla’s boutiques, galleries, and top-rated dining, plus some of San Diego’s most celebrated beaches and coves—all right outside your door.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "La Jolla Cove Apartments")&.id,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1615856530122-bfac378b313b?auto=format&fit=crop&w=1600&q=80", caption: "Coastal vibes in La Jolla—just minutes from the Cove." }
    ]
  },
  {
    title: "Live Steps from the Sand in Mission Beach",
    content: "Pacific Beach Residences at 789 Mission Blvd puts you in the heart of Mission Beach—just moments from the sand, surf, and the iconic boardwalk.\n\nWalk to local cafés, restaurants, boutique shops, and waterfront fun, with Pacific Beach, Mission Bay, and Belmont Park all nearby. A perfect fit for a full-time beach lifestyle, weekend escape, or coastal investment in one of San Diego’s most sought-after zip codes.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Pacific Beach Residences")&.id,
    photos_attributes: [
      { url: "https://plus.unsplash.com/premium_photo-1669748158379-b1460474807c?auto=format&fit=crop&w=1600&q=80", caption: "Coastal living just minutes from the boardwalk and beach in Mission Beach." }
    ]
  },
  {
    title: "Live the Ocean Beach Lifestyle",
    content: "Welcome to Ocean Beach Villas at 1020 Cable St, San Diego, CA 92107—right in the heart of OB’s laid-back coastal scene.\n\nStep out to neighborhood cafés, local shops, and the sandy shoreline for sunset walks and beach days. A prime spot for a full-time home, weekend retreat, or investment in one of San Diego’s most iconic beach communities.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Ocean Beach Villas")&.id,
    photos_attributes: [
      { url: "https://plus.unsplash.com/premium_photo-1682629632657-4ac307921295?auto=format&fit=crop&w=1600&q=80", caption: "Coastal living just moments from the beach in Ocean Beach, San Diego." }
    ]
  },
  {
    title: "Live in the Heart of North Park",
    content: "Welcome to North Park Commons at 3030 30th St—right on iconic 30th Street in San Diego (92104). Step outside to top coffee shops, breweries, boutiques, and some of the neighborhood’s best restaurants.\n\nYou’re also minutes to Balboa Park, Downtown, and easy freeway access for quick beach days. A prime spot for anyone wanting walkable city energy with classic North Park charm.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "North Park Commons")&.id,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1574731907493-ab1e5447054b?auto=format&fit=crop&w=1600&q=80", caption: "North Park vibes—walkable streets, local shops, and neighborhood charm." }
    ]
  },
  {
    title: "Live Where San Diego Comes Alive",
    content: "Welcome to Hillcrest Gardens at 402 University Ave—right in the heart of 92103. Enjoy a walkable lifestyle minutes from Hillcrest’s dining, coffee shops, and boutiques, plus easy access to Mission Hills, Balboa Park, and Downtown.\n\nWith quick freeway connections, nearby medical centers, and San Diego’s beaches and trails close by, this location is perfect for a stylish home base or a smart investment. Schedule a showing and experience the energy of this iconic neighborhood.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Hillcrest Gardens")&.id,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1574731947907-b6cb422cbbbd?auto=format&fit=crop&w=1600&q=80", caption: "Walkable city living near Hillcrest, Balboa Park, and Downtown San Diego." }
    ]
  },
  {
    title: "Mission Valley Living, Minutes from It All",
    content: "Welcome to Mission Valley Place at 210 Rio Vista St—right in the heart of San Diego’s 92108. Enjoy unbeatable convenience with quick freeway access and an easy drive to Downtown, Old Town, and the coast.\n\nSpend weekends shopping and dining at Fashion Valley and Westfield Mission Valley, then unwind at nearby parks and trails. A prime location that makes everyday San Diego living effortless.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Mission Valley Place")&.id,
    photos_attributes: [
      { url: "https://plus.unsplash.com/premium_photo-1661840348789-d4305454faa8?auto=format&fit=crop&w=1600&q=80", caption: "Mission Valley-inspired home exterior vibes in sunny San Diego." }
    ]
  },
  {
    title: "Live Steps from the Best of Coronado",
    content: "Welcome to Coronado Bay Residences at 101 Orange Ave—an unbeatable address in the heart of the island. Enjoy easy access to charming boutiques, celebrated dining, and the iconic Coronado shoreline.\n\nStart your day with a coffee walk, cruise to the beach by bike, and end with a sunset stroll—plus parks and waterfront attractions are just minutes away. Ideal as a full-time home, second-home retreat, or coastal investment.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Coronado Bay Residences")&.id,
    photos_attributes: [
      { url: "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&w=1600&q=80", caption: "Coastal living just minutes from the shoreline in Coronado." }
    ]
  },
  {
    title: "Live Where Little Italy Meets the Bay",
    content: "Welcome to Little Italy Flats at 225 India St—set in the heart of San Diego’s most vibrant waterfront neighborhood. Step outside to celebrated restaurants, cozy cafés, boutique shopping, and year-round community events.\n\nJust minutes from the bay, the Embarcadero, and Seaport Village, this prime downtown location makes it easy to enjoy sunset strolls, weekend adventures, and effortless freeway access for commuting.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Little Italy Flats")&.id,
    photos_attributes: [
      { url: "https://plus.unsplash.com/premium_photo-1690046121652-147b18f6be51?auto=format&fit=crop&w=1600&q=80", caption: "Downtown San Diego coastal living near the waterfront" }
    ]
  },
  {
    title: "Point Loma Living, Minutes from It All",
    content: "Welcome to Point Loma Harbor Homes at 1601 Rosecrans St—an unbeatable coastal San Diego location near the waterfront, marinas, and local favorites.\n\nEnjoy quick access to Liberty Station, Shelter Island, and the scenic bay, plus nearby shops, cafes, and everyday essentials. Downtown San Diego, Mission Bay, and the airport are just minutes away—perfect for a connected, laid-back seaside lifestyle.",
    scheduled_date: Time.now + 1.day,
    property_id: Property.find_by(name: "Point Loma Harbor Homes")&.id,
    photos_attributes: [
      { url: "https://plus.unsplash.com/premium_photo-1666875930610-85775f7d50b1?auto=format&fit=crop&w=1600&q=80", caption: "Coastal San Diego vibes near Point Loma’s waterfront and marinas." }
    ]
  }
]

example_posts.each do |attrs|
  post = Post.find_or_create_by(title: attrs[:title]) do |p|
		p.content = attrs[:content]
		p.scheduled_date = attrs[:scheduled_date]
    p.property_id = attrs[:property_id]
	end

  if attrs[:photos_attributes]
    attrs[:photos_attributes].each do |photo_attrs|
      post.photos.find_or_create_by(url: photo_attrs[:url]) do |photo|
        photo.caption = photo_attrs[:caption]
      end
    end
  end
end
