((trips_namespace, $, undefined_) ->

  trips_namespace.closeOverviewModal = ->
    $('#trip_overview_modal').modal('hide')
    $('.mapModalMask').fadeOut('slow')

  # Open Trip Overview Modal on load if show:true, set show:false for not show on load
  jQuery ->
    $('#trip_overview_modal').modal({show: true})
    $('.mapModalMask').fadeIn('slow') #show masking on load

    $("#swipewrapper").on "click", "#trip_overview_show", (e) ->
      $('#trip_overview_modal').modal('show')

    $("#overviewHide").click ->
      trips_namespace.closeOverviewModal()
      document.querySelector('#navswipe .selected').className = 'mediaa';
      dots = document.querySelectorAll('#navswipe li');
      dots[trips_namespace.slides[trips_namespace.gallery.pageIndex].activityday].className = 'mediaa selected';

    $("#trip_overview_modal").on "show", (e) ->
      $('.mapModalMask').fadeIn('slow')
      trips_activities_namespace.fireAjaxMapCall(1);
    $("#trip_overview_modal").on "hide", (e) ->
      $('.mapModalMask').fadeOut('slow')
    # $("#swipewrapper").on "click", "#trip_overview_show", (e) ->
    #   trips_activities_namespace.closeMapModal()
    # $('#trip_overview_modal').modal('show') #commented out so doesnt show on load
    # $("#trip_overview_modal").on "shown", ->
  	 #  $(document).off "focusin.modal"

) window.trips_namespace = window.trips_namespace or {}, jQuery