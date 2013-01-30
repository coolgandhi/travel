class AddImageUrlsToLocationDetails < ActiveRecord::Migration
  def change
    add_column :location_details, :image_urls, :text
  end
end
