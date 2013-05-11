class CreateTripFeedbacks < ActiveRecord::Migration
  def change
    create_table :trip_feedbacks do |t|
      t.string :trip_id
      t.text :feedback

      t.timestamps
    end
  end
end
