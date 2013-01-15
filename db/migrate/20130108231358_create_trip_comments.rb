class CreateTripComments < ActiveRecord::Migration
  def change
    create_table :trip_comments do |t|
      t.string :trip_id
      t.string :comment

      t.timestamps
    end
  end
end
