((trips_activities_namespace, $, undefined_) ->

  jQuery ->	
    $('.create_form_show_images_location').click ->
      site_wide_namespace.fetchvenueimages($("#location_activity_location_detail_id").val(), $("#venue_images"))

    $('.create_form_show_images_food').click ->
      site_wide_namespace.fetchvenueimages($("#food_activity_restaurant_detail_id").val(), $("#venue_images"))

) window.trips_activities_namespace = window.trips_activities_namespace or {}, jQuery