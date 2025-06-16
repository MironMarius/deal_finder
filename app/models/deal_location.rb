class DealLocation < ApplicationRecord
  belongs_to :deal, inverse_of: :deal_locations
  belongs_to :location, inverse_of: :location_deals
end
