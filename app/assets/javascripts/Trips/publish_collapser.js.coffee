((trips_namespace, $, undefined_) ->
  jQuery ->  
    headers = $(".publish_trip_collapse_header")
    contentAreas = $(".publish_trip_collapse_content")
    headerIcons = $(this).next().find('.collapser_icon i')
    $(".publish_form_activity_details_content").hide()
    
    #change icon on hide / show
    $(".publish_trip_collapse_content").on "show", ->
      $(this).prev(".publish_trip_collapse_header").find(".collapser_icon i").removeClass("icon-chevron-down").addClass("icon-chevron-up")
      $('.alert').hide();

    $(".publish_trip_collapse_content").on "hide", ->
      $(this).prev(".publish_trip_collapse_header").find(".collapser_icon i").removeClass("icon-chevron-up").addClass("icon-chevron-down")
    
    headers.click ->
      panel = $(this).next()
      panelIcon = $(this).find('.collapser_icon i')
      isOpen = panel.is(":visible")
      
      # open or close as necessary
      # trigger the correct custom event
      panel[(if isOpen then "slideUp" else "slideDown")]().trigger (if isOpen then "hide" else "show")
      # if panel.is(":visible") then panelIcon.removeClass('icon-chevron-down').addClass('icon-chevron-up') else panelIcon.removeClass('icon-chevron-up').addClass('icon-chevron-down')

      # stop the link from causing a pagescroll
      false

) window.trips_namespace = window.trips_namespace or {}, jQuery