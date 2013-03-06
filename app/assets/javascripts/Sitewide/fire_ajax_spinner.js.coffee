((site_wide_namespace, $, undefined_) ->
  $(document).ajaxStart(->
    $(".swipe-loading-indicator-header").show()
  ).ajaxStop ->
    $(".swipe-loading-indicator-header").hide()

) window.trips_namespace = window.trips_namespace or {}, jQuery