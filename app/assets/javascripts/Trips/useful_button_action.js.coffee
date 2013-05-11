((trips_namespace, $, undefined_) ->
  
  jQuery ->
    $("#useful_button").click (e) ->
      e.preventDefault();
      $.ajax 
        url: $("#useful_button").data('usefulurl')
        type: 'get'
        dataType: 'script'
        contentType: false
        processData: false
      $('.trip_chalo_feedback_modal').modal('show')
      
    #close the modal on click or on esc button key press
    $('#cover_select_cancel_button').click ->
      $('.trip_chalo_feedback_modal').modal('hide')
      
) window.trips_namespace = window.trips_namespace or {}, jQuery

