module DealsHelper
  def format_location(deal)
    loc = deal.location
    "#{loc['city']}, #{loc['state']} #{loc['zipCode']}"
  end

  def deal_tags(deal)
    deal.tags.map { |tag| content_tag(:span, tag, class: "tag") }.join.html_safe
  end
end
