class FixImageColumnNameInTrips < ActiveRecord::Migration
  def up
    rename_column :trips, :image, :self_image
  end

  def down
  end
end
