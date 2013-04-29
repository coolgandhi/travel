((trips_namespace, $, undefined_) ->

  trips_namespace.closeOverviewModal = ->
    $('#trip_overview_modal').modal('hide')
    $('.mapModalMask').fadeOut('slow')

  # Open Trip Overview Modal on load if show:true, set show:false for not show on load
  jQuery ->
    $('#trip_overview_modal').modal({show: true})

    $("#swipewrapper").on "click", "#trip_overview_show", (e) ->
      $('#trip_overview_modal').modal('show')
      $('.mapModalMask').fadeIn('slow')

    $("#overviewHide").click ->
      trips_namespace.closeOverviewModal()
    # $("#swipewrapper").on "click", "#trip_overview_show", (e) ->
    #   trips_activities_namespace.closeMapModal()
    # $('#trip_overview_modal').modal('show') #commented out so doesnt show on load
    # $("#trip_overview_modal").on "shown", ->
  	 #  $(document).off "focusin.modal"

) window.trips_namespace = window.trips_namespace or {}, jQuery