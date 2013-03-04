((site_wide_namespace, $, undefined_) ->
  # passing location value of the dropdown search place field to hidden fields in hero-unit
  jQuery ->
  	$('.place_dropdown_field').change ->
      $('.trip_location_id').val($('.place_dropdown_field').val())

) window.site_wide_namespace = window.site_wide_namespace or {}, jQuery