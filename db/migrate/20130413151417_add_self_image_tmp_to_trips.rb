class AddSelfImageTmpToTrips < ActiveRecord::Migration
  def change
    add_column :trips, :self_image_tmp, :text
  end
end
