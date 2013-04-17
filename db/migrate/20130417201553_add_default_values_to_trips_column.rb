class AddDefaultValuesToTripsColumn < ActiveRecord::Migration
  def change
    change_column :trips, :duration, :string, :default => "1"
    change_column :trips, :rank_score, :integer, :default => 0
    change_column :trips, :trip_name, :string, :default => "My Fun Trip"
    change_column :trips, :trip_summary, :string, :default => "Please add a quick summary"
    change_column :trips, :tags, :text, :default => ""
    change_column :trips, :traveler_type_id, :string, :default => "1"     
  end
end
