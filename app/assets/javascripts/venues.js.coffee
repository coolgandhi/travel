# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

totalSelectedImages = 0;

jQuery ->        
  $('#locationvenue').autocomplete
    minLength: 3
    source: (request, response) ->
      $.ajax 
        url: window.location.protocol + "//" + window.location.host + "/venues/pick.json"
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
      fetchvenueimages ui.item.value

jQuery ->        
  $('#foodvenue').autocomplete
    minLength: 3
    source: (request, response) ->
      $.ajax 
        url: window.location.protocol + "//" + window.location.host + "/venues/pick.json"
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
      fetchvenueimages ui.item.value
      
jQuery ->
  $("#venue_images img").live "click", ->
    if ($(this).css("borderWidth") == '5px') 
      $(this).css("border",'1px solid black')
      totalSelectedImages--
    else 
      if totalSelectedImages == 5
        alert "5 images selected already, unselect one"
      else
        $(this).css("border",'5px solid blue')
        totalSelectedImages++
    return
  return



jQuery ->
  $("#trip_form_submit").click ->
    dat = ""
    $('#venue_images').children().each (index, data) ->
      if ($(this).css("borderWidth") == '5px')
        da = $(this).data('img')
        dat = dat + da.img + ";"
    $('#selected_images').val(dat)    
    return
  return
  
  
fetchvenueimages = (venueid) ->
  $.ajax 
    url: window.location.protocol + "//" + window.location.host + "/venues/get_venue_photos.json"
    dataType: "json"
    data: 
      total: 20
      venueid: venueid
    success: (data) ->
      $("#venue_images").empty()
      $.each data.venue_photos, (i, name) ->
        $("#venue_images").append("<img data id=" + "img_" + i  + " class='venue_image' src='" + name.img + "'/>")
        return
      $.each data.venue_photos_com, (i, name) ->
        $('#img_' + i).data('img', name)
        return
      return
  return