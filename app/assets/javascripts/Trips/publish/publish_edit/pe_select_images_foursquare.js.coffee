((trips_activities_namespace, $, undefined_) ->
  
  jQuery ->
    $('.publish_trip_create_activities').on "click", ".ta_pick_from_foursquare", ->
      $('.pe_select_image_4SQ_modal').modal('show')
      foursquare_id = $('#venue_id').val();
      site_wide_namespace.fetchvenueimages(foursquare_id, $(".4SQ_images_select_div"))


) window.trips_activities_namespace = window.trips_activities_namespace or {}, jQuery