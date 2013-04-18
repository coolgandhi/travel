((trips_namespace, $, undefined_) ->

  jQuery ->
    unless $('#place_text_field').val() != ""
      $('#place_text_field').focus()

) window.trips_namespace = window.trips_namespace or {}, jQuery