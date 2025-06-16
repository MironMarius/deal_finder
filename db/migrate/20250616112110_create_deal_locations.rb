class CreateDealLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :deal_locations do |t|
      t.references :deal, null: false, foreign_key: true
      t.references :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
