((site_wide_namespace, $, undefined_) ->

  jQuery ->
    $('.selectpicker').select2()
    $('.results_day_field').select2
      placeholder: "# of days (optional)"
      minimumResultsForSearch: -1
    $('.selectpicker2').select2
      placeholder: "Where would you like to go?"

) window.site_wide_namespace = window.site_wide_namespace or {}, jQuery
