class CreateFoodActivities < ActiveRecord::Migration
  def change
    create_table :food_activities do |t|
      t.string : activity_id
      t.string :restaurant_details_id
      t.string :description
      t.string :quick_tip
      t.string :duration

      t.timestamps
    end
  end
end
