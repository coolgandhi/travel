module LocationsHelper

  def get_city_name location_id
    location_detail = Location.find_by_location_id(location_id)
    location_detail.city
  end
end
