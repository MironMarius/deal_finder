class Location < ApplicationRecord
  has_many :location_deals, class_name: "DealLocation", inverse_of: :location
  has_many :deals, through: :location_deals

  validates_presence_of :latitude, :longitude, :address, :city, :state, :zipcode
end
