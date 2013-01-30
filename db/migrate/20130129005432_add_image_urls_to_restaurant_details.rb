class AddImageUrlsToRestaurantDetails < ActiveRecord::Migration
  def change
    add_column :restaurant_details, :image_urls, :string
  end
end
