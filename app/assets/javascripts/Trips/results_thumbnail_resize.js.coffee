((trips_namespace, $, undefined_) ->
  trips_namespace.fire_picturefill = ->
    # create a jQuery deferred object
    r = $.Deferred()
    picturefill()
    setTimeout (->  
      # and call `resolve` on the deferred object, once you're done
      r.resolve()
    ), 500
    # return the deferred object
    r
  
  trips_namespace.fireResizeResultsPic = ->
    $(".image_link_thumbnail").resizeToParent parent: ".result_thumb_wrap"

  jQuery ->
    trips_namespace.fireResizeResultsPic()
    $(window).on "resize", -> trips_namespace.fireResizeResultsPic()
    $(window).on "orientationchange", -> trips_namespace.fireResizeResultsPic()
    $("a[data-toggle=\"tab\"]").on "shown", (e) ->
      trips_namespace.fireResizeResultsPic()
    # fire_picturefill()
    # fire_picturefill().done fireResizeResultsPic
    # $(window).on "resize", fireResizeResultsPic

) window.trips_namespace = window.trips_namespace or {}, jQuery