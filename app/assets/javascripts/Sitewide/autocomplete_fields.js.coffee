
((site_wide_namespace, $, undefined_) ->

  totalSelectedImages = 0;
  
  jQuery ->        
    $('#place_text_field, .place_text_field').autocomplete
      minLength: 3
      source: (request, response) ->
        $.ajax 
          url: window.location.protocol + "//" + window.location.host + "/locations/pick.json"
          dataType: "json"
          data: 
            total: 10
            near: request.term
          success: (data) -> 
            response $.map(data, (item) ->
                label: item.city + ", " + item.state + ", " + item.country 
                value: item.location_id + "," + item.latitude + "," + item.longitude
              )
      open: ->
        $(this).removeClass("#place_text_field").addClass "ui-corner-top"
      close: ->
        $(this).removeClass("ui-corner-top").addClass "ui-corner-all"
      focus: (event, ui) ->
        event.preventDefault()
        $(this).val ui.item.label
      select: (event, ui) ->
        event.preventDefault()
        splitarrayvalue = ui.item.value.split(",")
        splitarraylabel = ui.item.label.split(",")
        $('#trip_location_id, .trip_location_id').val( splitarrayvalue[0] )
        $(this).val ui.item.label
        $(this).siblings('#place_text_field').val splitarrayvalue[0]
        site_wide_namespace.fetchlocationimages splitarraylabel[0], splitarrayvalue[1], splitarrayvalue[2], $("#location_images")
        return
    return
  return
) window.site_wide_namespace = window.site_wide_namespace or {}, jQuery