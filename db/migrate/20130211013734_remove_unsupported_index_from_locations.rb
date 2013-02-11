class RemoveUnsupportedIndexFromLocations < ActiveRecord::Migration
  def up
    remove_index :locations, :name=>'city_index'
  end

  def down
    add_index :locations, :city, :name=>'city_index'
  end
end
