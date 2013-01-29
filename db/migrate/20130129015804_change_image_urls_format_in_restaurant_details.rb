class ChangeImageUrlsFormatInRestaurantDetails < ActiveRecord::Migration
  def self.up
    change_column :restaurant_details, :image_urls, :text
  end

  def self.down
    change_column :restaurant_details, :image_urls, :string
  end
end
