((trips_namespace, $, undefined_) ->

  # Open Trip Overview Modal on load 
  jQuery ->
    $('#trip_overview_modal').modal({show: false})
    $('.overview_button').click ->
      trips_activities_namespace.closeMapModal()
    # $('#trip_overview_modal').modal('show') #commented out so doesnt show on load
    $("#trip_overview_modal").on "shown", ->
  	  $(document).off "focusin.modal"

) window.trips_namespace = window.trips_namespace or {}, jQuery