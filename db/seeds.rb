# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
require 'pry'

data = File.read(Rails.root.join('db', 'seeds', 'data.json'))
data = JSON.parse(data)


data.each do |deal_data|
  location_data = deal_data['location']
  location = Location.find_or_create_by!(
    address: location_data['address'],
    latitude: location_data['lat'],
    longitude: location_data['lng'],
    city: location_data['city'],
    state: location_data['state'],
    zipcode: location_data['zipCode']
  )
  pp "Creating location: #{location.address}"

  deal = Deal.create!(
    title: deal_data['title'],
    description: deal_data['description'],
    original_price: deal_data['originalPrice'],
    discount_price: deal_data['discountPrice'],
    discount_percentage: deal_data['discountPercentage'],
    category: deal_data['category'],
    subcategory: deal_data['subcategory'],
    tags: deal_data['tags'],
    merchant_name: deal_data['merchantName'],
    merchant_rating: deal_data['merchantRating'],
    quantity_sold: deal_data['quantitySold'],
    expiry_date: deal_data['expiryDate'],
    featured_deal: deal_data['featuredDeal'],
    image_url: deal_data['imageUrl'],
    fine_print: deal_data['finePrint'],
    review_count: deal_data['reviewCount'],
    average_rating: deal_data['averageRating'],
    available_quantity: deal_data['availableQuantity'],
  )
  pp "Creating deal: #{deal.title}"

  DealLocation.create!(
    location: location,
    deal: deal
  )
end
