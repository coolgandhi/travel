class CreateTripStats < ActiveRecord::Migration
  def change
    create_table :trip_stats do |t|
      t.string :trip_id
      t.float :total_rating
      t.integer :numbers_rated
      t.integer :likes
      t.integer :tweets
      t.integer :fb_shared
      t.integer :pinned
      t.integer :emailed

      t.timestamps
    end
  end
end
