
trips_activities_namespace = trips_activities_namespace || {}

((trips_activities_namespace, undefined_) ->

  jQuery ->
    $("#swipewrapper").on "click", "#mapShowHide", (e) ->
      $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.back').show()
      if Modernizr.csstransitions
        $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').toggleClass('flipped')
      else
        $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.front').toggle('slow')
      $(this).parents('#moreShowHideGroup').siblings('.always-here').toggleClass('always-here-hide')
      $(this).toggleClass("icon-globe").toggleClass("icon-picture").toggleClass("active")

  jQuery ->
    $("#swipewrapper").on "click", "#mapShowHide", (e) ->
      req = slides[gallery.pageIndex].tripid + "/trip_activities/" + slides[gallery.pageIndex].activityid + "/mapinfo"
      mapcontainer = $(this).parents('#moreShowHideGroup').siblings('.flip-container').find('#trip_map')
      $.ajax
        beforeSend: ->
          $(".swipe-loading-indicator").show()
        type: "GET"
        url: req  
        dataType: "json"
        context: mapcontainer #maintaining the context of $this to pass forward into success callback functions
        complete: ->
          $(".swipe-loading-indicator").hide()
        success: (data) ->
          restore(mapcontainer)
          addmarkers(data, mapcontainer)
          addMarkerLabels(data, mapcontainer)
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
        # options:
        #   icon: "/assets/" + data[i].logo
    return if arrobject.length < 1
    mapcontainer.gmap3
      marker:
        values: arrobject
        options:
          draggable: false
          # animation: google.maps.Animation.DROP
        events:
          click: () ->
          mouseover: (marker, event, context) ->
            map = $(this).gmap3("get")
            infowindow = $(this).gmap3(get:
              name: "infowindow"
            )
            if infowindow
              infowindow.setOptions({maxWidth:250})
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

  addMarkerLabels = (data, mapcontainer) ->
    arrobject = []
    $.each data, (i, name) ->
      spl = data[i].location.split(",")
      arrobject.push
        latLng: [parseFloat(spl[0]), parseFloat(spl[1])]
    console.log(arrobject)
    return if arrobject.length < 1
    mapcontainer.gmap3
      overlay:
        values: [{latLng:[48.8620722, 2.352047], data:"Paris !"},
        {latLng:[48.8620722, 10.352047], data:"Fii !"},
        {latLng:[48.8620722, 32.352047], data:"Bal !"}
        ]
        options:
          content: '<div style="color:#000000; background-color: #FF7C70; text-align:center; font-size: 11px; line-height: 11px;border-radius:50%; width: 16px; text-align:center;">2</div>'
          offset:
            y: -30
            x: -8
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
          strokeColor: "#8FD8D8"
          strokeOpacity: 0.6
          strokeWeight: 4
          path: arrobject

) trips_activities_namespace