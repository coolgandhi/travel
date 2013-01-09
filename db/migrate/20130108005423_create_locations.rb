class CreateLocations < ActiveRecord::Migration
  def change
    create_table :locations do |t|
      t.string : 
      t.string :location_id
      t.string :place
      t.string :city
      t.string :state
      t.string :country
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
