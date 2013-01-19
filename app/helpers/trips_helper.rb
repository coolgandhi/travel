module TripsHelper

	# this helper provides the view with a JSON object of the trip and all activities
	# def tripdetails_as_json(tripdetails)
	# 	mybungle = tripdetails.to_json
	# 	parseable = JSON.parse(mybungle)
	# 	# parseable = ActiveSupport::JSON.decode(mybungle)
	# 	blahblah = parseable.map {|x| {rightcaption: x[1]["description"], quicktip: x[1]["quick_tip"]}}
	# 	prettyup = JSON.pretty_generate(blahblah)
	# 	prettyup
	# end

		# this helper provides the view with a JSON object of the trip and all activities
	def trip_activities_as_json
		mybungle = {:trip => @trip,:trip_activity => @trip.trip_activities,:trip_activities_details => @trip_activities_details}
		parseable = mybungle.to_json
		parsedbungle = JSON.parse(parseable)
		t = parsedbungle["trip"]
		s = parsedbungle["trip_activity"]
		x = parsedbungle["trip_activities_details"]
		# # blahblah = x.map {|e| {rightcaption: e[1]["description"], quicktip: e[1]["quick_tip"], tripname: t["trip_name"], activityday: @trip_activity[:activity_id] }}
		# mapping the trip, trip_activity and trip_activities_detail into a formatted JSON object
		mappedbungle = s.map {|e| {activityday: e["activity_day"], activitysequence: e["activity_sequence_number"], tripname: t["trip_name"], 
							   rightcaption: @trip_activities_details[e["activity_id"].to_s]["description"], 
							   quicktip: @trip_activities_details[e["activity_id"].to_s]["quick_tip"], duration: @trip_activities_details[e["activity_id"].to_s]["duration"] }}
		# sorting this JSON by sequence number
		sortedbungle = mappedbungle.sort { |j, k| [j[:activityday], j[:activitysequence]] <=> [k[:activityday], k[:activitysequence]] }
		prettybungle = JSON.pretty_generate(sortedbungle)
		prettybungle
	end

end
