class AddSlugToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :slug, :string
    add_index :trips, :slug, :name=>'trip_slug_index'
  end
end
