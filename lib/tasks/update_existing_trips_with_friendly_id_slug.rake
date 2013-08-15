require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :db do
   
  desc "Update existing trips with friendly trip id slug"
  task :update_existing_trips_with_friendly_trip_id_slug => :environment do

    Trips.find_each(&:save) 
    
  end
end