class CreateDeals < ActiveRecord::Migration[8.0]
  def change
    create_table :deals do |t|
      t.string :title
      t.text :description

      t.float :original_price
      t.float :discount_price
      t.float :discount_percentage

      t.string :category
      t.string :subcategory
      t.string :tags, array: true

      t.string :merchant_name
      t.float :merchant_rating

      t.integer :quantity_sold
      t.date :expiry_date
      t.boolean :featured_deal
      t.string :image_url
      t.text :fine_print
      t.integer :review_count
      t.float :average_rating
      t.integer :available_quantity

      t.timestamps
    end
  end
end
