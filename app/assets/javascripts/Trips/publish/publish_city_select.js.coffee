((trips_namespace, $, undefined_) ->

  jQuery ->
    $('.publish_place_dropdown_field').change ->
      console.log($('select.publish_place_dropdown_field option:selected').text().split(',')[0])
      $('#trip_location_id').val($('.publish_place_dropdown_field').val())
      
      $.ajax 
        url: window.location.protocol + "//" + window.location.host + "/locations/pick.json"
        dataType: "json"
        data: 
          total: 10
          near: $('select.publish_place_dropdown_field option:selected').text().split(',')[0]
        success: (data, item) -> 
          if $('#trip_trip_summary') then $('#trip_trip_summary').val("Tell us more about the time you went to " + data[0].city) #on select put an auto summary
          if $('#trip_trip_name') then $('#trip_trip_name').val("My Awesome Time in "+ data[0].city) #on select put an auto title
          $('#latlong').val (data[0].latitude+","+data[0].longitude)
          $('#locationval').val (data[0].city)
          
) window.trips_namespace = window.trips_namespace or {}, jQuery