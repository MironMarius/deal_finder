module DealsFilters
  private

  def apply_filters
    filters = @params[:filters]
    return if filters.blank?

    @deals = @deals.where(featured_deal: true) if filters[:featured_deal] == "true"
    @deals = @deals.where(category: filters[:category]) if filters[:category].present?
    @deals = @deals.where(subcategory: filters[:subcategory]) if filters[:subcategory].present?

    apply_tag_filter(filters) if filters[:tags].present?
    apply_price_filter(filters) if filters[:min_price].present? || filters[:max_price].present?
  end

  def apply_sorting
    unless @params[:sort]
      @deals = @deals.sort_by { |deal| deal.instance_variable_get(:@score) }.reverse
      return
    end

    dir = @params[:sort_direction].to_sym

    case @params[:sort]
    when "discount"
      @deals = @deals.order(discount_percentage: dir)
    when "rating"
      @deals = @deals.order(merchant_rating: dir)
    when "price"
      @deals = @deals.order(discount_price: dir)
    when "popularity"
      @deals = @deals.order(quantity_sold: dir)
    when "distance"
      @deals = @deals.order(Arel.sql("distance #{dir.to_s.upcase}"))
    end
  end

  def apply_tag_filter(filters)
    tags = filters[:tags].split(",").map(&:strip)
    @deals = @deals.where("tags && ARRAY[?]::varchar[]", tags)
  end

  def apply_price_filter(filters)
    min_price = filters[:min_price].to_f
    max_price = filters[:max_price].to_f
    @deals = @deals.where(discount_price: min_price..max_price)
  end
end
