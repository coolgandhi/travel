((trips_namespace, $, undefined_) ->
  
  jQuery ->
    $("#useful_button").click ->
      trips_namespace.closeOverviewModal();
      trips_activities_namespace.closeMapModal();
      $.ajax 
        url: $("#useful_button").data('usefulurl')
        type: 'get'
        dataType: 'script'
        contentType: false
        processData: false
        complete: ->
          $("#useful_button").attr("disabled", true);
      $('.trip_chalo_feedback_modal').modal('show')
      
    #close the modal on cancel click
    $('#feedback_cancel_button').click ->
      $('.trip_chalo_feedback_modal').modal('hide');

) window.trips_namespace = window.trips_namespace or {}, jQuery

