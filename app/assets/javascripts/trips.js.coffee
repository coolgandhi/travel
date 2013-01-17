
jQuery ->        
  $('#place').autocomplete
    source: (request, response) ->
      $.ajax 
        url: "http://localhost:8080/locations/pick.json"
        dataType: "json"
        minLength: 2
        data: 
          total: 10
          near: request.term
        success: (data) ->
          response $.map(data, (item) ->
            $('#trip_location_id').val( item.location_id )
            label: item.city + ", " + item.state + ", " + item.country
            value: item.city + ", " + item.country
            )