((trips_namespace, $, undefined_) ->
  
  trips_namespace.wrap_heights = ->
    # create a jQuery deferred object
    r = $.Deferred()
    num = 0.7
    num_map = 0.9
    if Modernizr.touch or site_wide_namespace.isMobile.any()
      num = 1.5 
    $('#wrappiest').css "height", "" + Math.round(num * $(window).height())
    $('.wrapper_film').css "height", "" + Math.round(num * $(window).height())
    $('#trip_map_big_view_modal').css "height", "" + Math.round(num_map * $(window).height())    
    $('.modal_big_map').css "height", "" + Math.round(num_map * $(window).height())
    setTimeout (->  
      # and call `resolve` on the deferred object, once you're done
      r.resolve()
    ), 2500
    # return the deferred object
    r

  trips_namespace.wrap_widths = ->
    num_map = 0.9
    #$('#comments').css "width", "" + Math.round(.7 * $(window).width())
    $('#trip_map_big_view_modal').css "width", "" + Math.round(num_map * $(window).width())
    $('.modal_big_map').css "width", "" + Math.round(num_map * $(window).width())
  

  #this initiates the iscrolls
  trips_namespace.create_iscrollers = ->
    if Modernizr.touch
      filmScroller = new iScroll("filmstrip-scroll")
      commentScroller = new iScroll("bottom_actionlinks")
      overviewScroller = new iScroll("trip_overview_modal")
      frontPageConvoScroller = new iScroll("front_page_convo_wrapper")
    else
     	''

  # calling the methods above
  $(document).ready ->
    trips_namespace.wrap_heights()
    trips_namespace.wrap_widths()
    $(window).on "resize", -> 
      trips_namespace.wrap_heights()
      trips_namespace.wrap_widths()
    $(window).on "orientationchange", -> 
      trips_namespace.wrap_heights()
      trips_namespace.wrap_widths()
    # # $(window).on "resize", wrap_widths
    trips_namespace.wrap_heights().done trips_namespace.create_iscrollers
    
) window.trips_namespace = window.trips_namespace or {}, jQuery