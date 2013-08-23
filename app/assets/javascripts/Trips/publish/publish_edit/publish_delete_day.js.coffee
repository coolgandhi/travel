((trips_namespace, $, undefined_) ->
  
  jQuery ->
    if (navigator.userAgent.indexOf("MSIE 10") > 0)      
      $('input.publish_form_delete_day').mousedown ->
        $(this).trigger('click')

) window.trips_namespace = window.trips_namespace or {}, jQuery

