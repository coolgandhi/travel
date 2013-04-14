((trips_namespace, $, undefined_) ->
  jQuery ->  
    $('.dummy_next_step').click ->
      $('.publish_form_activity_details_content').show()
      alert 'next steps loaded'

) window.trips_namespace = window.trips_namespace or {}, jQuery