module Deals
  SORTING_OPTIONS = %w[discount rating price popularity distance].freeze
  EARTH_RADIUS = 6371 # in kilometers

  private

  def calculate_scores
    @deals.each do |deal|
      score = deal.calculate_score
      # Adjust score based on distance if available
      score = score - 0.2 + deal.distance_score(deal.distance) if deal.respond_to?(:distance)

      deal.instance_variable_set(:@score, score)
    end
  end

  def distance_query
    lat = @params[:lat].to_f
    long = @params[:long].to_f

    ActiveRecord::Base.sanitize_sql_array([
      "deals.*, " +
      "(#{EARTH_RADIUS} * acos(cos(radians(?))* cos(radians(locations.latitude)) * cos(radians(locations.longitude) " +
      "- radians(?)) + sin(radians(?)) * sin(radians(locations.latitude)))) " +
      "AS distance", lat, long, lat
    ])
  end

  def validate_distance
    return unless @params[:sort] == "distance"
    return if @params[:lat].present? && @params[:long].present?

    err_bad_request("lat and long must be provided for distance sorting")
  end

  def validate_sorting
    return unless @params[:sort]
    return err_bad_request("Invalid sort option") if SORTING_OPTIONS.exclude?(@params[:sort])
    return err_bad_request("Sort direction must be provided") unless @params[:sort_direction]

    err_bad_request("Invalid sort direction") unless %w[asc desc].include?(@params[:sort_direction])
  end

  def validate_price
    filters = @params[:filters] || {}
    return if filters[:min_price].blank? && filters[:max_price].blank?
    return if is_number?(filters[:min_price]) && is_number?(filters[:max_price])

    err_bad_request("min_price / max_price must be numbers")
  end

  def is_number?(str)
    Float(str) rescue false
  end
end
