((trips_namespace, $, undefined_) ->
          
  jQuery ->          
    $('#publish_place_dropdown_field').autocomplete
      minLength: 3
      source: (request, response) ->
        $.ajax 
          url: "http://ws.geonames.org/searchJSON"
          dataType: 'jsonp'
          data: 
            style: 'full'
            name_startsWith: request.term
            maxRows: 15
            featureClass: 'P' 
            username: 'coolgandhi'
          success: (data) ->
            response $.map(data.geonames, (item) ->
              label: item.name + ", " + item.adminName1 + ", " + item.countryName
              value: item
              )
      open: ->
        $(this).removeClass("#publish_place_dropdown_field").addClass "ui-corner-top"
      close: ->
        $(this).removeClass("ui-corner-top").addClass "ui-corner-all"
      focus: (event, ui) ->
        event.preventDefault()
        $(this).val ui.item.label      
      select: (event, ui) ->
        event.preventDefault()
        $(this).val ui.item.label
        if $('#trip_trip_summary') then $('#trip_trip_summary').val("Tell us more about the time you went to " + ui.item.value.name) #on select put an auto summary
        if $('#trip_trip_name') then $('#trip_trip_name').val("My Awesome Time in "+ ui.item.value.name) #on select put an auto title
        $('#latlong').val (ui.item.value.lat + "," + ui.item.value.lng )
        $('#locationval').val(ui.item.value.name + "," + ui.item.value.adminName1 + "," + ui.item.value.countryName)
        $('#trip_location_id').val(ui.item.value.geonameId)
        
        
      $('#publish_place_dropdown_label').tooltip
        placement: "top"
        title: "Place searches powered by geonames.org"
        trigger: "hover"
      
        
) window.trips_namespace = window.trips_namespace or {}, jQuery