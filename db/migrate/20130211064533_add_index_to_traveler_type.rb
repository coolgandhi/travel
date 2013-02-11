class AddIndexToTravelerType < ActiveRecord::Migration
  def up
    add_index :traveler_types, :traveler_type_id, :name=>'traveler_type_index'
  end
  def down
    remove_index :traveler_types, :traveler_type_id
  end
end
