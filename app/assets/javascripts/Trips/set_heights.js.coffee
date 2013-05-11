((trips_namespace, $, undefined_) ->
  
  trips_namespace.wrap_heights = ->
    # create a jQuery deferred object
    r = $.Deferred()
    $('#wrappiest').css "height", "" + Math.round(.9 * $(window).height())
    $('.wrapper_film').css "height", "" + Math.round(.9 * $(window).height())
    setTimeout (->  
      # and call `resolve` on the deferred object, once you're done
      r.resolve()
    ), 2500
    # return the deferred object
    r

  trips_namespace.wrap_widths = ->
    $('#comments').css "width", "" + Math.round(.6 * $(window).width())

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
    # # wrap_widths()
    $(window).on "resize", -> trips_namespace.wrap_heights()
    $(window).on "orientationchange", -> trips_namespace.wrap_heights()
    # # $(window).on "resize", wrap_widths
    trips_namespace.wrap_heights().done trips_namespace.create_iscrollers
    
) window.trips_namespace = window.trips_namespace or {}, jQuery