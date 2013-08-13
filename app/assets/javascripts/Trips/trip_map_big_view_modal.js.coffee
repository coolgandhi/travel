((trips_namespace, $, undefined_) ->

  jQuery ->
    $('.big_map_launch_button').click ->
      map_day = $(this).data('day')
      req = trips_namespace.slides[trips_namespace.gallery.pageIndex].tripid + "/daymapinfo"
      mapcontainer = $(".modal_big_map")
      $.ajax
        beforeSend: ->
          $(".swipe_loading_indicator").show()
        type: "GET"
        url: req
        data: {activity_day: map_day}
        dataType: "json"
        context: mapcontainer #maintaining the context of $this to pass forward into success callback functions
        complete: ->
          $(".swipe_loading_indicator").hide()
        success: (data) ->
          trips_activities_namespace.restore(mapcontainer)
          trips_activities_namespace.addmarkers(data, mapcontainer)
          return     
    
  
) window.trips_namespace = window.trips_namespace or {}, jQuery

