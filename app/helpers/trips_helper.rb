module TripsHelper

  # this helper provides the view with an arrary of trip and all activities
  def sorted_trip_activities trip
    trip_location = @trip.location[:place]
    
    mapped_activities = Array.new
    trip.trip_activities.each {|trip_activity| 
        image_url = ""
        activity_venue_name = ""
        lay_out = ""
        case trip_activity.activity_type 
            when "FoodActivity" then 
              image_url = trip_activity.activity.restaurant_detail[:image_urls]   
              activity_venue_name= trip_activity.activity.restaurant_detail[:name]
              lay_out = "foodactivitypartial"
            when "LocationActivity" then 
              image_url = trip_activity.activity.location_detail[:image_urls]
              activity_venue_name = trip_activity.activity.location_detail[:name]
              lay_out = "locationactivitypartial"
            else  # default transport activity
              image_url = ""
              activity_venue_name = ""
              lay_out= "transportactivitypartial"
        end
      
        if trip_activity.activity.image_urls and trip_activity.activity.image_urls != ""
          image_url = trip_activity.activity.image_urls # select image from the activity if chosen by the author
        end
        
        mapped_activities.push (
          { 
            :activityday => trip_activity.activity_day, 
            :activitysequence => trip_activity.activity_sequence_number, 
            :activityid => trip_activity.id,
            :tripname => trip.trip_name,
            :triplength => trip.duration, 
            :triplocation => trip_location, 
            :tripid =>  trip.id,
            :rightcaption => trip_activity.activity.description, 
            :quicktip => trip_activity.activity.quick_tip, 
            :duration => trip_activity.activity.duration,
            :timetype => trip_activity.activity_time_type,
            :image_url => image_url,
            :activity_venue_name => activity_venue_name,
            :renderpartial => "/trips/#{trip.id}/trip_activities/#{trip_activity.id}/showpartial/", 
            :layout => lay_out   
          }
        )             
    }

    # # sorting this JSON by sequence number
    sorted_activities = mapped_activities.sort {|j, k| 
        [j[:activityday], 
        j[:activitysequence]] <=> [k[:activityday], 
        k[:activitysequence]] 
      }

    sorted_activities.push({renderpartial: "/trips/#{trip.id}/showpartial/", layout: "about_author"})
    sorted_activities
  end
end
