class AddIndexToTripActivitiesAndAuthor < ActiveRecord::Migration
  def up
    add_index :author_infos, :email, :name=>'auth_email_index', :unique => true
    add_index :trip_activities, [:trip_id, :activity_day, :activity_sequence_number], :unique => true, :name=>'trip_activity_order_index' 
  end
  def down
    remove_index :author_infos, :name=>'auth_email_index'
    remove_index :trip_activities, :name=>'trip_activity_order_index' 
  end
end
