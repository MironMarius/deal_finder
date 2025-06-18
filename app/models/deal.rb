class Deal < ApplicationRecord
  MAX_DISTANCE = 3000 # in meters
  SCORING_WEIGHTS = {
    discount: 0.3,
    rating: 0.2,
    popularity: 0.2,
    distance: 0.2,
    featured: 0.1
  }.freeze

  has_many :deal_locations
  has_many :locations, through: :deal_locations

  validates_presence_of :title, :description, :original_price, :discount_price, :discount_percentage,
                        :category, :subcategory, :tags, :merchant_name, :merchant_rating, :quantity_sold,
                        :expiry_date, :image_url

  validates_numericality_of :original_price, :discount_price, :discount_percentage, :merchant_rating, :quantity_sold

  scope :not_expired, -> { where("expiry_date >= ?", Date.today) }
  scope :available, -> { where("available_quantity > 0") }

  def calculate_score
    discount_score = discount_percentage / 100
    rating_score = merchant_rating / 5.0
    popularity_score = quantity_sold / (quantity_sold + available_quantity).to_f
    featured_score = featured_deal ? 1 : 0

    [
      discount_score * SCORING_WEIGHTS[:discount] +
      rating_score * SCORING_WEIGHTS[:rating] +
      popularity_score * SCORING_WEIGHTS[:popularity] +
      featured_score * SCORING_WEIGHTS[:featured] +
      0.2, # substitute for distance_score
      1.0
    ].min
  end

  # by default, user might not provide their location
  # so we add it separately if available
  def distance_score(distance)
    if distance < MAX_DISTANCE
      score = (MAX_DISTANCE - distance.to_f) / MAX_DISTANCE
    else
      score = 0
    end

    score * SCORING_WEIGHTS[:distance]
  end

  def available_quantity
    super || 0
  end
end
