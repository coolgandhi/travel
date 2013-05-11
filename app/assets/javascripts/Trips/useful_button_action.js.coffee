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

) window.trips_namespace = window.trips_namespace or {}, jQuery

