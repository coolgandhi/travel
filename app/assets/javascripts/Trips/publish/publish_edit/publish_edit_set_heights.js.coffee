((trips_namespace, $, undefined_) ->
  
  trips_namespace.publish_activity_div_heights = ->
    # create a jQuery deferred object
    r = $.Deferred()
    $('.publish_form_activity_details_content').css "height", "" + Math.round(.5 * $(window).height())
    # $('.publish_trip_sort_activities').css "height", "" + Math.round(.5 * $(window).height())
    # $('.publish_trip_create_activities').css "height", "" + Math.round(.5 * $(window).height())
    setTimeout (->  
      # and call `resolve` on the deferred object, once you're done
      r.resolve()
    ), 2500
    # return the deferred object
    r

  # calling the methods above
  $(document).ready ->
    trips_namespace.publish_activity_div_heights()
    $(".publish_form_activity_details_content").on "click", ".publish_order_day_tabs", (e) ->
      trips_namespace.publish_activity_div_heights()
      console.log("rezieadheights")
    $(window).on "resize", -> trips_namespace.publish_activity_div_heights()
    $(window).on "orientationchange", -> trips_namespace.publish_activity_div_heights()

) window.trips_namespace = window.trips_namespace or {}, jQuery