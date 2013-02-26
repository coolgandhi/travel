class AddLocationIdToLocationDetails < ActiveRecord::Migration
  def change
    add_column :location_details, :location_id, :string
  end
end
