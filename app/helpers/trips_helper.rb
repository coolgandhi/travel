module TripsHelper

	def tripdetails_as_json(tripdetails)
		mybungle = tripdetails.to_json
		parseable = JSON.parse(mybungle)
		# parseable = ActiveSupport::JSON.decode(mybungle)
		blahblah = parseable.map {|x| {rightcaption: x[1]["description"], quicktip: x[1]["quick_tip"]}}
		prettyup = JSON.pretty_generate(blahblah)
		prettyup
	end
end
