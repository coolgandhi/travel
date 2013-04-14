class CreateSelfTripActivityPhotos < ActiveRecord::Migration
  def change
    create_table :self_trip_activity_photos do |t|
      t.text :self_photo
      t.text :self_photo_tmp
      t.string :activity_id

      t.timestamps
    end
  end
end
