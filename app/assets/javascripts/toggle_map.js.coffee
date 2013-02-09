
jQuery ->
  #using the .on jQuery function to delegate unbinded jquery function to AJAX loaded div
  # $("#swipewrapper").on "click", "#mapShowHide", (e) -> 
  #   $(".hiddenMapDiv").fadeToggle "slow"
  
  # $("#swipewrapper").on "click", "#flipper-check", (e) -> 
  #   $(this).siblings('.flipper').flip
  #     direction: "tb", content: $(".back")
  $("#swipewrapper").on "click", "#mapShowHide", (e) ->
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.back').show()
    # $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.extraside').hide()
    # $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').removeClass('flipped-again')
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').toggleClass('flipped')
    $(this).parents('#moreShowHideGroup').siblings('.always-here').toggleClass('always-here-hide')
    $(this).toggleClass("icon-globe").toggleClass("icon-picture").toggleClass("active")
    # $(this).toggleClass('active').promise().done ->
    #   if $(this).class = "active" then $(this).siblings('#infoShowHide').removeClass('active') && $(this).siblings('#hideAllButton').removeClass('active')
    #   if $(this).hasClass('active') == false then $(this).siblings('#hideAllButton').addClass('active')

  # $("#swipewrapper").on "click", "#infoShowHide", (e) ->
  #   $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.extraside').show()
  #   $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.back').hide()
  #   $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').removeClass('flipped')
  #   $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').toggleClass('flipped-again')
  #   $(this).toggleClass('active').promise().done -> 
  #     if $(this).class = "active" then $(this).siblings('#mapShowHide').removeClass('active') && $(this).siblings('#hideAllButton').removeClass('active')
  #     if $(this).hasClass('active') == false then $(this).siblings('#hideAllButton').addClass('active')


  # $("#swipewrapper").on "click", "#hideAllButton", (e) ->
  #   $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').removeClass('flipped')
  #   $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').removeClass('flipped-again')
  #   $(this).addClass('active')
  #   $(this).siblings('.btn').removeClass('active')


jQuery ->
  $("#swipewrapper").on "click", "#mapShowHide", (e) ->
    req = slides[gallery.pageIndex].tripid + "/trip_activities/" + slides[gallery.pageIndex].activityid + "/mapinfo"
    mapcontainer = $(this).parents('#moreShowHideGroup').siblings('.flip-container').find('#trip_map')
    $.ajax
      type: "GET"
      url: req  
      dataType: "json"
      context: mapcontainer #maintaining the context of $this to pass forward into success callback functions
      success: (data) ->
        restore(mapcontainer)
        addmarkers(data, mapcontainer)
        addpolyline(data, mapcontainer)        
        return       
              
# don't need this anymore since we can load multiple maps
restore = (mapcontainer) ->
  mapcontainer.gmap3 action: "destroy"
  # container = mapcontainer.parent()
  # mapcontainer.remove()
  # container.append "<div id=\"trip_map\"></div>"
  return

addmarkers = (data, mapcontainer) ->
  arrobject = []
  $.each data, (i, name) ->
    spl = data[i].location.split(",")
    arrobject.push
      latLng: [parseFloat(spl[0]), parseFloat(spl[1])]
      data: data[i].name
      options:
        icon: "/assets/" + data[i].logo
  return if arrobject.length < 1
  mapcontainer.gmap3
    marker:
      values: arrobject
      options:
        draggable: false
      events:
        click: () ->
        mouseover: (marker, event, context) ->
          map = $(this).gmap3("get")
          infowindow = $(this).gmap3(get:
            name: "infowindow"
          )
          if infowindow
            infowindow.open map, marker
            infowindow.setContent context.data
            return
          else
            $(this).gmap3 infowindow:
              anchor: marker
              options:
                content: context.data
            return
        mouseout: ->
          infowindow = $(this).gmap3(get:
            name: "infowindow"
          )
          infowindow.close()  if infowindow
          return
    autofit: {}
  return 

      
getdirections = (data, showcontainer = false) ->
  arrobject = []
  orig = null
  dest = null
  $.each data, (i, name) ->
    if i == 0
      orig = data[i].location
      return
    else if i == data.length - 1
      dest = data[i].location
      return
    else
      spl = data[i].location.split(",")
      arrobject.push
        location: new google.maps.LatLng(parseFloat(spl[0]), parseFloat(spl[1]))
        stopover: true
      return
  return if orig == null or dest == null
  $("#trip_map").gmap3
    getroute:
      options:
        origin: orig
        destination: dest
        travelMode: google.maps.DirectionsTravelMode.DRIVING
        waypoints: arrobject
      callback: (results) ->
        return  unless results
        $(this).gmap3
          directionsrenderer:
            container: (if (showcontainer is false) then null else $(document.createElement("div")).addClass("googlemap").insertAfter($("#trip_map")))
            options:
              directions:results
              hideRouteList: true
              preserveViewport: true
              suppressMarkers: true
        return
  return
  
  
addpolyline = (data, mapcontainer) ->
  arrobject = []
  $.each data, (i, name) ->
    spl = data[i].location.split(",")
    arrobject.push [parseFloat(spl[0]), parseFloat(spl[1])]
    return
  return if arrobject.length < 2
  mapcontainer.gmap3
    polyline:
      options:
        strokeColor: "#FF0000"
        strokeOpacity: 1.0
        strokeWeight: 2
        path: arrobject
