
((site_wide_namespace, $, undefined_) ->
  site_wide_namespace.fetchvenueimages = (venueid, container) ->
    $.ajax 
      url: window.location.protocol + "//" + window.location.host + "/venues/get_venue_photos.json"
      dataType: "json"
      data: 
        total: 60
        venueid: venueid
      success: (data) ->
        container.empty()
        $.each data.venue_photos_100, (i, name) ->
          container.append("<img data id=" + "img_" + i  + " class='venue_image' src='" + name.img + "'/>")
          return
        $.each data.venue_photos_com, (i, name) ->
          $('#img_' + i).data('img', name)
          return
      complete: ->
        trips_activities_namespace.make_venue_images_selectable();
        $(".select_image_spinner").hide();
        return
    return  
  
  
  site_wide_namespace.fetchlocationimages =  (place, latitude, longitude, container) ->
    $.ajax 
      url: window.location.protocol + "//" + window.location.host + "/venues/get_venue_photos.json"
      dataType: "json"
      data: 
        total: 100
        latitude: latitude
        longitude: longitude
        place: place
      success: (data) ->
        container.empty()
        if data.venue_photos == null
          alert ("no images extracted")
          return
        $.each data.venue_photos_100, (i, name) ->
          container.append("<img data id=" + "img_" + i  + " class='venue_image' src='" + name.img + "'/>")
          return
        $.each data.venue_photos_com, (i, name) ->
          $('#img_' + i).data('img', name)
          return
        return
      complete: ->
        trips_activities_namespace.make_cover_images_selectable();
        $(".select_cover_image_spinner").hide();
    return
  return
      
) window.site_wide_namespace = window.site_wide_namespace or {}, jQuery