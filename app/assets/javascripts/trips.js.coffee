
jQuery ->        
  $('#trip_location_id').autocomplete
    source: (request, response) ->
      $.ajax 
        url: "http://ws.geonames.org/searchJSON"
        dataType: "jsonp"
        data: 
          featureClass: "P"
          maxRows: 12
          name_startsWith: request.term
        success: (data) ->
          response $.map(data.geonames, (item) ->
            label: item.name + ((if item.adminName1 then ", " + item.adminName1 else "")) + ", " + item.countryName
            value: item.lat + ", " + item.lng
            )