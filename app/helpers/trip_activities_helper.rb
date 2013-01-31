module TripActivitiesHelper

	def check_empty_detail(attribute)
		attribute == "" ? "--" : attribute
	end

	def select_activity_img(which_activity)
		x = which_activity.activity.restaurant_detail[:image_urls]
		y = x.to_s.split(";")
		z = y.map {|x| x.split(",") } #z is in the format of
        #[["https://is1.4sqi.net/pix/77727_kohZm1hN4NDZ6kQVznu7SGUkWk7NeJz6W9Xwa_heiqk.jpg", "612X612", "https://is0.4sqi.net/derived_pix/77727_kohZm1hN4NDZ6kQVznu7SGUkWk7NeJz6W9Xwa_heiqk_300x300.jpg", "300X300", "https://is0.4sqi.net/derived_pix/77727_kohZm1hN4NDZ6kQVznu7SGUkWk7NeJz6W9Xwa_heiqk_100x100.jpg", "100X100", "https://is0.4sqi.net/derived_pix/77727_kohZm1hN4NDZ6kQVznu7SGUkWk7NeJz6W9Xwa_heiqk_36x36.jpg", "36X36"],...]
        #z[picture][size]. odd index numbers are the dimensions and even are urls to the right size in descending size order
	end

	def show_thumbnail(i)
		if (JSON.parse(trip_activities_as_json))[i]["activityid"]
			activity_id = (JSON.parse(trip_activities_as_json))[i]["activityid"] # takes the json that we built in trips_helper and parses it so we can access the current page's activityid
			image_urls = select_activity_img(TripActivity.find(activity_id)) # find that activity id and pass it into another helper method that returns image_urls
			image_urls[0][2] # access the array of image_urls.  [0] is first image [2] is the 2nd lowest quality url
		else
			"view_from_notre_dame_flickr_large.jpg"
		end
	end

end
