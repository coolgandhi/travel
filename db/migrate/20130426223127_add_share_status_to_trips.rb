class AddShareStatusToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :share_status, :integer, :default => 1
  end
end
