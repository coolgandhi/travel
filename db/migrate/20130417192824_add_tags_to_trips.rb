class AddTagsToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :tags, :text
  end
end
