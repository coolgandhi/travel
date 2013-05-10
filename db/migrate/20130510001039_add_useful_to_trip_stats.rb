class AddUsefulToTripStats < ActiveRecord::Migration
  def change
    add_column :trip_stats, :useful, :integer, :default => 0
  end
end
