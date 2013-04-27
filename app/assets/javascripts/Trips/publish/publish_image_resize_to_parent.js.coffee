((trips_namespace, $, undefined_) ->

  jQuery ->
    trips_namespace.fireResizePublishImages = ->
      $(".pt_activity_upload_img").resizeToParent parent: "#yes_upload_div"
    trips_namespace.fireResizePublishImages();
    $('.publish_trip_collapse_content').on "show", (e) ->
      trips_namespace.fireResizePublishImages();


) window.trips_namespace = window.trips_namespace or {}, jQuery