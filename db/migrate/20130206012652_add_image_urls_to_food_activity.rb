class AddImageUrlsToFoodActivity < ActiveRecord::Migration
  def change
    add_column :food_activities, :image_urls, :text
  end
end
