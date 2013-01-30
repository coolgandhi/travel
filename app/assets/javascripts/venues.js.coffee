# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->        
  $('#locationvenue').autocomplete
    minLength: 3
    source: (request, response) ->
      $.ajax 
        url: "http://localhost:5678/venues/pick.json"
        dataType: "json"
        data: 
          total: 10
          ven: request.term
          latlong: $('#trip_activity_latlong').val()
        success: (data) ->
          response $.map(data, (item) ->
            $('#location_activity_location_detail_id').val(item.value)
            label: item.label + ", " + item.address + ", " + item.city
            value: item.value
            )
    open: ->
      $(this).removeClass("#locationvenue").addClass "ui-corner-top"
    close: ->
      $(this).removeClass("ui-corner-top").addClass "ui-corner-all"
    focus: (event, ui) ->
      event.preventDefault()
      $(this).val ui.item.label      
    select: (event, ui) ->
      event.preventDefault()
      $('#location_activity_location_detail_id').val( ui.item.value )
      $(this).val ui.item.label
      $(this).siblings('#locationvenue').val ui.item.value

jQuery ->        
  $('#foodvenue').autocomplete
    minLength: 3
    source: (request, response) ->
      $.ajax 
        url: "http://localhost:5678/venues/pick.json"
        dataType: "json"
        data: 
          total: 10
          ven: request.term
          latlong: $('#trip_activity_latlong').val()
        success: (data) ->
          response $.map(data, (item) ->
            $('#food_activity_restaurant_detail_id').val(item.value)
            label: item.label + ", " + item.address + ", " + item.city
            value: item.value
            )
    open: ->
      $(this).removeClass("#foodvenue").addClass "ui-corner-top"
    close: ->
      $(this).removeClass("ui-corner-top").addClass "ui-corner-all"
    focus: (event, ui) ->
      event.preventDefault()
      $(this).val ui.item.label      
    select: (event, ui) ->
      event.preventDefault()
      $('#food_activity_restaurant_detail_id').val( ui.item.value )
      $(this).val ui.item.label
      $(this).siblings('#foodvenue').val ui.item.value   