((site_wide_namespace, $, undefined_) ->
  $(document).ajaxStart(->
    $(".swipe_loading_indicator_header").show()
  ).ajaxStop ->
    $(".swipe_loading_indicator_header").hide()

) window.trips_namespace = window.trips_namespace or {}, jQuery