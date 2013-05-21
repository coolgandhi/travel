((trips_namespace, $, undefined_) ->

  jQuery ->
    $('.author_level_tooltip').tooltip(
      template: '<div class="tooltip al_solid_bg"><div class="tooltip-arrow"></div><div class="tooltip-inner"></div></div>'
    )

) window.trips_namespace = window.trips_namespace or {}, jQuery