((trips_namespace, $, undefined_) ->

  totalSelectedImages = 0;
  
  jQuery ->        
    $('#place').autocomplete
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
        $(this).removeClass("#place").addClass "ui-corner-top"
      close: ->
        $(this).removeClass("ui-corner-top").addClass "ui-corner-all"
      focus: (event, ui) ->
        event.preventDefault()
        $(this).val ui.item.label      
      select: (event, ui) ->
        event.preventDefault()
        splitarrayvalue = ui.item.value.split(",")
        splitarraylabel = ui.item.label.split(",")
        $('#trip_location_id').val( splitarrayvalue[0] )
        $(this).val ui.item.label
        $(this).siblings('#place').val splitarrayvalue[0]
        site_wide_namespace.fetchlocationimages splitarraylabel[0], splitarrayvalue[1], splitarrayvalue[2], $("#location_images")
      
  # Open Trip Overview Modal on load 
  jQuery ->
    $('#trip-overview-modal').modal('show')
    
    
  jQuery ->
    $("#location_images").on "click", "img", (e) ->
      if ($(this).css("borderWidth") == '5px') 
        $(this).css("border",'1px solid black')
        totalSelectedImages--
      else 
        if totalSelectedImages == 1
          alert "1 image selected already"
        else
          $(this).css("border",'5px solid blue')
          totalSelectedImages++
      return
    return



  jQuery ->
    $("#trip_form_submit").click ->
      dat = ""
      $('#location_images').children().each (index, data) ->
        if ($(this).css("borderWidth") == '5px')
          da = $(this).data('img')
          dat = dat + da.img + ";"
      $('#selected_images').val(dat)    
      return
    return


) window.trips_namespace = window.trips_namespace or {}, jQuery