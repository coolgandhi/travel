
((trips_activities_namespace, $, undefined_) ->

  # jQuery ->
  #   $("#swipewrapper").on "click", "#mapShowHide", (e) ->
  #     $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.back').show()
  #     if Modernizr.csstransitions
  #       $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').toggleClass('flipped')
  #     else
  #       $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.front').toggle('slow')
  #     $(this).parents('#moreShowHideGroup').siblings('.always_here').toggleClass('always_here_hide')
  #     $(this).toggleClass("icon-globe").toggleClass("icon-picture").toggleClass("active")
  #     $('#mapModal').modal('toggle')

  trips_activities_namespace.closeMapModal = ->
    $('#mapModal').modal('hide')
    $('.mapModalMask').fadeOut('slow')

  # jQuery ->
  #   $("#swipewrapper").on "click", "#mapShow", (e) ->
  #     $('#mapModal').modal('show')
  #     $('.mapModalMask').fadeIn('slow')

  jQuery ->
    $("#mapHide").click ->
      trips_activities_namespace.closeMapModal()

  jQuery ->
    $(document).bind "keydown", (e) ->
      $('.mapModalMask').fadeOut('slow') if e.which is 27

    trips_activities_namespace.fireAjaxMapCall = (map_day) ->
      req = trips_namespace.slides[trips_namespace.gallery.pageIndex].tripid + "/daymapinfo"
      mapcontainer = $("#modal_map_"+ map_day)
      $.ajax
        beforeSend: ->
          $(".swipe_loading_indicator").show()
          $('#map_tabs a.class_map_day_'+map_day).tab('show')
        type: "GET"
        url: req
        data: {activity_day: map_day}
        dataType: "json"
        context: mapcontainer #maintaining the context of $this to pass forward into success callback functions
        complete: ->
          $(".swipe_loading_indicator").hide()
        success: (data) ->
          restore(mapcontainer)
          addmarkers(data, mapcontainer)
          # addpolyline(data, mapcontainer)
          return     

    # fire map day 1 on load
    trips_activities_namespace.fireAjaxMapCall(1);


  jQuery ->
    $("#map_tabs a.daymapinfo, #map_tabs li.dropdown ul.dropdown-menu li a.daymapinfo").click (e) ->
      e.preventDefault()
      req = trips_namespace.slides[trips_namespace.gallery.pageIndex].tripid + "/daymapinfo"
      map_day = $(this).data('day')
      map_day_index = $(this).data('day') - 1 
      mapcontainer = $("#b_modal_map_"+ map_day)

      $.ajax
        beforeSend: ->
          $(".swipe_loading_indicator").show()
          $('#map_tabs a.class_map_day_'+map_day).tab('show')
        type: "GET"
        url: req
        data: {activity_day: map_day}
        dataType: "json"
        context: mapcontainer #maintaining the context of $this to pass forward into success callback functions
        complete: ->
          $(".swipe_loading_indicator").hide()
        success: (data) ->
          restore(mapcontainer)
          addmarkers(data, mapcontainer)
          addpolyline(data, mapcontainer)
          return     

          
  jQuery ->
    #this is for the combined map and overview list view.
    $("#overview_modal_day_tabs a.overview_modal_day_tabs, #overview_modal_day_tabs li.dropdown ul.dropdown-menu li a.overview_modal_day_tabs").click (e) ->
      e.preventDefault()
      map_day = $(this).data('day')
      map_day_index = $(this).data('day') - 1 
      trips_activities_namespace.fireAjaxMapCall(map_day);


    $("#swipewrapper").on "click", "#mapShow", (e) ->
      req = trips_namespace.slides[trips_namespace.gallery.pageIndex].tripid + "/trip_activities/" + trips_namespace.slides[trips_namespace.gallery.pageIndex].activityid + "/mapinfo"
      map_day = trips_namespace.slides[trips_namespace.gallery.pageIndex].activityday
      map_day_index = trips_namespace.slides[trips_namespace.gallery.pageIndex].activityday - 1 
      mapcontainer = $("#b_modal_map_"+ map_day)

      $.ajax
        beforeSend: ->
          $(".swipe_loading_indicator").show()
          $('#mapModal').modal('show')
          $('.mapModalMask').fadeIn('slow')
          $('#map_tabs li:eq(' + map_day_index + ') a').tab('show')
        type: "GET"
        url: req
        dataType: "json"
        context: mapcontainer #maintaining the context of $this to pass forward into success callback functions
        complete: ->
          $(".swipe_loading_indicator").hide()
        success: (data) ->
          restore(mapcontainer)
          addmarkers(data, mapcontainer)
          addpolyline(data, mapcontainer)
          return       
                    
  restore = (mapcontainer) ->
    mapcontainer.gmap3('destroy') 
    # container = mapcontainer.parent()
    # mapcontainer.remove()
    # container.append '<div id="modal_map"></div>'
    return

  addmarkers = (data, mapcontainer) ->
    arrobject = []
    $.each data, (i, name) ->
      spl = data[i].location.split(",")
      arrobject.push
        latLng: [parseFloat(spl[0]), parseFloat(spl[1])]
        data: data[i].name + data[i].address
        options:
          #construction for icon is 1. make map MarkerImage - specify sprite URL, specify size of image, specify origin from top left corner, specify anchor point of where the pin should be centered (not based on sprite but based on the 40x40 image)
          icon: new google.maps.MarkerImage("/assets/markers/" + data[i].logo, new google.maps.Size(40, 40), new google.maps.Point(4+((i%10)*47), 4+((Math.floor(i/10)*40))), new google.maps.Point(11.5, 37.9)) 
    return if arrobject.length < 1
    mapcontainer.gmap3
      # map:
      #   events:
      #     idle: () ->
      #       map = $(this).gmap3("get") #gets the google map rendered object
      #       google.maps.event.addListener(map, "drag", ->
      #         console.log("yoyoyo")
      #         google.maps.event.clearListeners(map, "drag") #this needs to be here or listeners multiply
      #       )
      marker:
        values: arrobject
        options:
          draggable: false
          animation: google.maps.Animation.DROP
        events:
          click: () ->
          mouseover: (marker, event, context) ->
            map = $(this).gmap3("get")
            infowindow = $(this).gmap3(get:
              name: "infowindow"
            )
            if infowindow
              # infowindow.setOptions({maxWidth:50, pixelOffset:new google.maps.Size(0, 60)})
              infowindow.setOptions({disableAutoPan: true})
              infowindow.open map, marker
              infowindow.setContent context.data           
              return
            else
              $(this).gmap3 infowindow:
                anchor: marker
                options:
                  content: context.data
                  disableAutoPan: true
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
          strokeColor: "#8FD8D8"
          strokeOpacity: 0.6
          strokeWeight: 4
          path: arrobject

) window.trips_activities_namespace = window.trips_activities_namespace or {}, jQuery
