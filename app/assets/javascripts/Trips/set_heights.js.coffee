((trips_namespace, $, undefined_) ->
  
  wrap_heights = ->
    # create a jQuery deferred object
    r = $.Deferred()
    $('#wrappiest').css "height", "" + Math.round(.7 * $(window).height())
    $('.wrapper-film').css "height", "" + Math.round(.7 * $(window).height())
    setTimeout (->  
      # and call `resolve` on the deferred object, once you're done
      r.resolve()
    ), 2500
    # return the deferred object
    r

  wrap_widths = ->
    $('#comments').css "width", "" + Math.round(.6 * $(window).width())

  #this initiates the iscrolls
  create_iscrollers = ->
    if Modernizr.touch
      filmScroller = new iScroll("filmstrip-scroll")
      commentScroller = new iScroll("bottom-actionlinks")
      overviewScroller = new iScroll("trip-overview-modal")
    else
     	console.log('no touch')

  # calling the methods above
  $(document).ready ->
    wrap_heights()
    # wrap_widths()
    $(window).on "resize", wrap_heights
    # $(window).on "resize", wrap_widths
    wrap_heights().done create_iscrollers
    
) window.trips_namespace = window.trips_namespace or {}, jQuery