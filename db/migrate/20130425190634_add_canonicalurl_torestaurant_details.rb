class AddCanonicalurlTorestaurantDetails < ActiveRecord::Migration
  def change
    add_column :restaurant_details, :canonical_url, :string
    add_column :location_details, :canonical_url, :string
  end
end
