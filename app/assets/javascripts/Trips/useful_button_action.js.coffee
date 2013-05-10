((trips_namespace, $, undefined_) ->
  
  jQuery ->
    $("#useful_button").click ->
      $.ajax 
        url: $("#useful_button").attr('data')
        type: 'get'
        dataType: 'script'
        contentType: false
        processData: false

) window.trips_namespace = window.trips_namespace or {}, jQuery

