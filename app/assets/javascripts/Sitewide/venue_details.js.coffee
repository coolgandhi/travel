
((site_wide_namespace, $, undefined_) ->
  site_wide_namespace.fetchvenueimages = (venueid, container) ->
    $.ajax 
      url: window.location.protocol + "//" + window.location.host + "/venues/get_venue_photos.json"
      dataType: "json"
      data: 
        total: 20
        venueid: venueid
      success: (data) ->
        container.empty()
        $.each data.venue_photos, (i, name) ->
          container.append("<img data id=" + "img_" + i  + " class='venue_image' src='" + name.img + "'/>")
          return
        $.each data.venue_photos_com, (i, name) ->
          $('#img_' + i).data('img', name)
          return
        return
    return  
  
  
  site_wide_namespace.fetchlocationimages =  (place, latitude, longitude, container) ->
    $.ajax 
      url: window.location.protocol + "//" + window.location.host + "/venues/get_venue_photos.json"
      dataType: "json"
      data: 
        total: 20
        latitude: latitude
        longitude: longitude
        place: place
      success: (data) ->
        container.empty()
        if data.venue_photos == null
          alert ("no images extracted")
          return
        $.each data.venue_photos, (i, name) ->
          container.append("<img data id=" + "img_" + i  + " class='venue_image' src='" + name.img + "'/>")
          return
        $.each data.venue_photos_com, (i, name) ->
          $('#img_' + i).data('img', name)
          return
        return
    return
  return
      
) window.site_wide_namespace = window.site_wide_namespace or {}, jQuery