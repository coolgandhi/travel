((site_wide_namespace, $, undefined_) ->

  jQuery ->
    $('.selectpicker').selectpicker()
    $('.select2picker').select2
      width: 220
      placeholder: "Where would you like to go?"
      allowClear: true
) window.site_wide_namespace = window.site_wide_namespace or {}, jQuery