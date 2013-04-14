class AddImageToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :image, :text
  end
end
