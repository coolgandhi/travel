
jQuery ->        
  $('#place').autocomplete
    minLength: 3
    source: (request, response) ->
      $.ajax 
        url: "http://localhost:5678/locations/pick.json"
        dataType: "json"
        data: 
          total: 10
          near: request.term
        success: (data) ->
          response $.map(data, (item) ->
            label: item.city + ", " + item.state + ", " + item.country 
            value: item.location_id
            )
    open: ->
      $(this).removeClass("#place").addClass "ui-corner-top"
    close: ->
      $(this).removeClass("ui-corner-top").addClass "ui-corner-all"
    focus: (event, ui) ->
      event.preventDefault()
      $(this).val ui.item.label      
    select: (event, ui) ->
      event.preventDefault()
      $('#trip_location_id').val( ui.item.value )
      $(this).val ui.item.label
      $(this).siblings('#place').val ui.item.value