((sitewide_namespace, $, undefined_) ->

  totalSelectedImages = 0;
    
    
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


) window.sitewide_namespace = window.sitewide_namespace or {}, jQuery