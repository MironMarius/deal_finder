FactoryBot.define do
  factory :deal do
    title { Faker::Commerce.product_name }
    description { Faker::Lorem.paragraph }
    original_price { Faker::Number.decimal(l_digits: 2, r_digits: 2) }
    discount_price { original_price * 0.6 }
    discount_percentage { 40 }
    category { "Food & Drink" }
    subcategory { "Japanese" }
    tags { [ "dinner", "restaurant" ] }
    merchant_name { Faker::Company.name }
    merchant_rating { 4.5 }
    quantity_sold { 50 }
    available_quantity { 100 }
    expiry_date { Faker::Date.forward(days: 30) }
    image_url { Faker::Internet.url }
    featured_deal { false }

    trait :featured do
      featured_deal { true }
    end

    trait :expired do
      expiry_date { Faker::Date.backward(days: 1) }
    end

    trait :not_expired do
      expiry_date { Faker::Date.forward(days: 30) }
    end

    trait :sold_out do
      available_quantity { 0 }
    end

    trait :high_discount do
      discount_percentage { Faker::Number.between(from: 50, to: 90) }
      discount_price { original_price * (1 - discount_percentage / 100) }
    end
  end
end
