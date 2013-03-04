require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :db do
   
  desc "Update restaurants database contents"
  task :updaterestaurants => :environment do
    i = 0
    j = 0
    if (ENV["UPDATE_RESTAURANTS"] and ENV["UPDATE_RESTAURANTS"].to_i == 1)
      RestaurantDetail.all.each { |restaurantdetail|
        if restaurantdetail.restaurant_detail_id != nil and restaurantdetail.restaurant_detail_id != "" and (restaurantdetail.updated_at < (DateTime.now - 30))
          create_food_venue restaurantdetail.restaurant_detail_id, restaurantdetail.location_id, 1
          sleep 1
          i = i + 1    
        end
        j = j + 1
      }
    end
    puts "updated #{i} out of total #{j} restaurant records"
  end
  
  desc "Update locations database contents"
  task :updatelocations => :environment do
    i = 0
    j = 0
    
    if (ENV["UPDATE_LOCATIONS"] and ENV["UPDATE_LOCATIONS"].to_i == 1)
      LocationDetail.all.each { |locationdetail|
        if locationdetail.location_detail_id != nil and locationdetail.location_detail_id != ""  and (locationdetail.updated_at < (DateTime.now - 30))
          create_location_venue locationdetail.location_detail_id, locationdetail.location_id, 1
          sleep 1
          i = i + 1
        end
        j = j + 1
      }
    end
    puts "updated #{i} out of total #{j} location records"
  end
  
  # rake UPDATE_LOCATIONS=1 UPDATE_RESTAURANTS=1 db:updatelandmarks
  
  desc "Update landmarks contents (only if they haven't been updated for 30 days)... set UPDATE_LOCATIONS to 1 for updating locations and UPDATE_RESTAURANTS to 1 for updating restaurants"
  task :updatelandmarks => [:updaterestaurants, :updatelocations]
end