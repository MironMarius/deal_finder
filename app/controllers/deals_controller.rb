class DealsController < ApplicationController
  include Deals
  include DealsFilters
  include ErrorMessages

  before_action :validate_params, only: [ :search ]
  def search
    @deals = Deal.not_expired
                 .available
                 .joins(:locations)

    # include distance to deal location if user provides their location
    @deals = @deals.select(distance_query) if params[:lat] && params[:long]

    apply_filters
    apply_sorting
    calculate_scores

    err_not_found if @deals.empty?
  end

  private

  def validate_params
    return unless params

    permitted_params = params&.permit(:sort, :sort_direction, :lat, :long,
                                    filters: [ :category, :subcategory, :featured_deal,
                                              :tags, :min_price, :max_price ])
    permitted_params.reject! { |_, v| v.blank? }
    permitted_params[:filters]&.reject! { |_, v| v.blank? }

    @params = permitted_params

    validate_price
    validate_sorting
    validate_distance
  end
end
