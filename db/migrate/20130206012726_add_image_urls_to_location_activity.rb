class AddImageUrlsToLocationActivity < ActiveRecord::Migration
  def change
    add_column :location_activities, :image_urls, :text
  end
end
