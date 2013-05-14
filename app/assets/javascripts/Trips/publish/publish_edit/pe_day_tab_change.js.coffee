((trips_namespace, $, undefined_) ->
  
  jQuery ->    
    trips_namespace.changeDayTabNewActivity = ->
      $('a.publish_order_day_tabs').click ->  
        whichTrip = $(this).data('tripid')
        whichDay = $(this).data('daytab')
        request_2 = $.ajax(
          url: window.location.protocol + "//" + window.location.host + "/trips/" + whichTrip + "/trip_activities/publish_trip_activity_new"   
          data: {day: whichDay}
          type: "get"
          dataType: "script"
        )

    trips_namespace.changeDayTabNewActivity();

) window.trips_namespace = window.trips_namespace or {}, jQuery