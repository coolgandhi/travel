module TripsHelper

  # this helper provides the view with an arrary of trip and all activities
  def sorted_trip_activities trip
    trip_location = @trip.location[:place]
    
    mapped_activities = Array.new
    trip.trip_activities.each {|trip_activity| 
        image_url = ""
        activity_venue_name = ""
        lay_out = ""
        category = ""
        case trip_activity.activity_type 
            when "FoodActivity" then 
              image_url = trip_activity.activity.restaurant_detail[:image_urls]   
              activity_venue_name = trip_activity.activity.restaurant_detail[:name]
              category = trip_activity.activity.restaurant_detail[:category]
              lay_out = "foodactivitypartial"
            when "LocationActivity" then 
              image_url = trip_activity.activity.location_detail[:image_urls]
              activity_venue_name = trip_activity.activity.location_detail[:name]
              category = trip_activity.activity.location_detail[:category]
              lay_out = "locationactivitypartial"
            else  # default transport activity
              image_url = ""
              activity_venue_name = ""
              category = ""
              lay_out= "transportactivitypartial"
        end
      
        if trip_activity.activity.image_urls and trip_activity.activity.image_urls != "" and trip_activity.activity.image_urls != nil
          image_url = trip_activity.activity.image_urls # select image from the activity if chosen by the author
        end
        
        mapped_activities.push (
          { 
            :activityday => trip_activity.activity_day, 
            :activitysequence => trip_activity.activity_sequence_number, 
            :activityid => trip_activity.id,
            :activitytype => trip_activity.activity_type,
            :tripname => trip.trip_name,
            :triplength => trip.duration, 
            :triplocation => trip_location, 
            :tripid =>  trip.id,
            :rightcaption => trip_activity.activity.description, 
            :quicktip => trip_activity.activity.quick_tip, 
            :duration => trip_activity.activity.duration,
            :timetype => trip_activity.activity_time_type,
            :category => category,
            :image_url => image_url,
            :activity_venue_name => activity_venue_name,
            :renderpartial => "/trips/#{trip.id}/trip_activities/#{trip_activity.id}/showpartial/", 
            :layout => lay_out   
          }
        )             
    }

    # # sorting this JSON by sequence number
    sorted_activities = mapped_activities.sort {|j, k| 
        f = ((j[:activityday].nil? or j[:activityday] == "") ? 0 : j[:activityday].to_i)
        g = (j[:activitysequence].nil? ) ? 0: j[:activitysequence]
        h = ((k[:activityday].nil? or k[:activityday] == "") ? 0 : k[:activityday].to_i)
        i = (k[:activitysequence].nil?) ? 0: k[:activitysequence]
        # logger.info "#{f}, #{g}.. #{h}, #{i} .... \n"
        [f, g] <=> [h, i]
      }


    sorted_activities.push({renderpartial: "/trips/#{trip.id}/showpartial/", layout: "about_author"})
    
    compressed_activities = Array.new
    sorted_activities.each { |sorted_activity|
      compressed_activities.push (
        {
          :activityid => sorted_activity[:activityid],
          :renderpartial => sorted_activity[:renderpartial],
          :layout => sorted_activity[:layout],
          :timetype => sorted_activity[:timetype],
          :tripid => sorted_activity[:tripid]
        }
      )
    }
    
    # logger.info " sorted #{compressed_activities.inspect}"

    return sorted_activities, compressed_activities
  end

  def avatar_url(author)  
    gravatar_id = Digest::MD5::hexdigest(author.email).downcase  
    "http://gravatar.com/avatar/#{gravatar_id}.png"  
  end  
end
