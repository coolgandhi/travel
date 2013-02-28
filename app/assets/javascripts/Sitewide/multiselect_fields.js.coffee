((site_wide_namespace, $, undefined_) ->

  $(document).ready ->
    $(".traveler-type-multiselect").multiselect(
      noneSelectedText: 'Your traveler type'
      selectedList: 4
      classes : "traveler-type-multiselect"
      height: 'auto'
    )

  $(document).ready ->
    $(".condensed-traveler-type-multiselect").multiselect(
      noneSelectedText: 'Your traveler type'
      selectedList: 4
      classes : "condensed-traveler-type-multiselect"
      height: 'auto'
    )

) window.site_wide_namespace = window.site_wide_namespace or {}, jQuery