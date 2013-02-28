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
  
  fireResizeResultsPic = ->
    $(".image-link-thumbnail").resizeToParent parent: ".results-thumb-wrap"

  $(document).ready ->
    fireResizeResultsPic()
    # fire_picturefill()
    # $(window).on "resize", fire_picturefill
    # fire_picturefill().done fireResizeResultsPic
    # $(window).on "resize", fireResizeResultsPic

) window.trips_namespace = window.trips_namespace or {}, jQuery