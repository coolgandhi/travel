((trips_namespace, $, undefined_) ->

  # Open Trip Overview Modal on load 
  jQuery ->
    $('.overview_button').click ->
      trips_activities_namespace.closeMapModal()
    $('#trip_overview_modal').modal('show')
    $("#trip_overview_modal").on "shown", ->
  	  $(document).off "focusin.modal"

) window.trips_namespace = window.trips_namespace or {}, jQuery