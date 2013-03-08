((trips_namespace, $, undefined_) ->
  fire_picturefill = ->
    # create a jQuery deferred object
    r = $.Deferred()
    picturefill()
    setTimeout (->  
      # and call `resolve` on the deferred object, once you're done
      r.resolve()
    ), 500
    # return the deferred object
    r
  
  fireResizeThumbnails = ->
    $(".thumb_image").resizeToParent parent: ".thumb_wrap"

  fireResizeSlideImages = ->
    $(".relative_image").resizeToParent parent: "#bloop"

  $(document).ready ->
    fire_picturefill()
    $(window).on "resize", fire_picturefill
    fire_picturefill().done fireResizeThumbnails	
    $(window).on "resize", fireResizeThumbnails
    $(window).on "resize", fireResizeSlideImages
  

  # jQuery ->
  #   $(".thumb_image").resizeToParent parent: ".thumb_wrap"


) window.trips_namespace = window.trips_namespace or {}, jQuery