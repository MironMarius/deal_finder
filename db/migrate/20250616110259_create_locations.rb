class CreateLocations < ActiveRecord::Migration[8.0]
  def change
    create_table :locations do |t|
      t.float :latitude
      t.float :longitude
      t.string :address
      t.string :city
      t.string :state
      t.string :zipcode

      t.timestamps
      t.index :address, unique: true
    end
  end
end
