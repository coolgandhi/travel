module TripActivitiesHelper

	def check_empty_detail(attribute)
		attribute == "" ? "--" : attribute
	end

	def select_activity_img
		x = @trip_activity.activity.restaurant_detail[:image_urls]
		h = ActiveSupport::JSON.decode(x)
		h # the JSON structure is h[0]["0"]["0"]["url"] to pull the url of the first image and the first size h[0][picture][size]["url"]
	end
end
