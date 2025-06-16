class Deal < ApplicationRecord
  has_many :deal_locations
  has_many :locations, through: :location_deals

  validates_presence_of :title, :description, :original_price, :discount_price, :discount_percentage,
                        :category, :subcategory, :tags, :merchant_name, :merchant_rating, :quantity_sold,
                        :expiry_date, :image_url

  validates_numericality_of :original_price, :discount_price, :discount_percentage, :merchant_rating, :quantity_sold
end
