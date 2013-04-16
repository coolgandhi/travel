class CreateRestaurantComments < ActiveRecord::Migration
  def change
    create_table :restaurant_comments do |t|
      t.string :source
      t.string :url
      t.string :name
      t.string :photo
      t.datetime :created_time
      t.string :summary
      t.string :restaurant_detail_id
      t.string :follow_post_id
      t.text :log

      t.timestamps
    end
  end
end
