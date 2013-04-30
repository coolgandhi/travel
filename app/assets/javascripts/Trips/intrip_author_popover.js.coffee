((trips_namespace, $, undefined_) ->
  #http://stackoverflow.com/questions/7703878/how-can-i-hold-twitter-bootstrap-popover-open-until-my-mouse-moves-into-it
  jQuery ->  
    $(".author_intrip_popover").popover(
      html: true
      offset: 10
      trigger: 'manual'
      placement: "bottom"
      title: "Title"
      template: '<div class="popover author_popover_outside" onmouseover="$(this).mouseleave(function() {$(this).hide(); });"><div class="arrow"></div><div class="popover-inner author_popover_inner"><div class="popover-content"><p></p></div></div></div>'
    ).click((e) ->
      e.preventDefault()
    ).mouseenter (e) ->
      $(this).popover "show"

) window.trips_namespace = window.trips_namespace or {}, jQuery