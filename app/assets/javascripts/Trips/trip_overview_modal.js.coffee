((trips_namespace, $, undefined_) ->

  # Open Trip Overview Modal on load 
  jQuery ->
    $('#trip-overview-modal').modal('show')

) window.trips_namespace = window.trips_namespace or {}, jQuery