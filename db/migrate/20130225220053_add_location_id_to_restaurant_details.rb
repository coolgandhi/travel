class AddLocationIdToRestaurantDetails < ActiveRecord::Migration
  def change
    add_column :restaurant_details, :location_id, :string
  end
end
