require "#{Rails.root}/app/helpers/application_helper"
include ApplicationHelper

namespace :db do
  
  desc "Populate or Update Author Stats"
  task :populate_or_update_author_stats => :environment do
    Trip.all.each { |trip|
     trip_stat = trip.trip_stat
      if trip_stat.blank?
       trip_stat = TripStat.new
       trip_stat = TripStat.new(:trip_id => trip.id, :author_info_id => trip.author_id, :trip_activities => trip.trip_activities.size, :trip_durations => trip.duration.to_i)
       trip_stat.save
      else
        if trip_stat.author_info_id.blank?
          trip_stat.author_info_id = trip.author_id
          trip_stat.save
        end
        if ((trip_stat.trip_activities == 0 or @trip_stats.trip_durations == 0) and trip.share_status == 1)
          trip_stat.trip_activities = trip.trip_activities.size
          trip_stat.trip_durations = trip.duration.to_i
          trip_stat.save
        end
      end
    }
  end
end