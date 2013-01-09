class CreateLocationDetails < ActiveRecord::Migration
  def change
    create_table :location_details do |t|
      t.string :location_detail_id
      t.string :name
      t.string :description
      t.string :category
      t.string :phone
      t.string :website
      t.string :open_hours
      t.string :address1
      t.string :address2
      t.string :address3
      t.string :city
      t.string :state
      t.string :country
      t.string :zip
      t.string :latitude
      t.string :longitude

      t.timestamps
    end
  end
end
