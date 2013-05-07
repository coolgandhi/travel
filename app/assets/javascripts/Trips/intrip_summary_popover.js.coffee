((trips_namespace, $, undefined_) ->
  #http://stackoverflow.com/questions/7703878/how-can-i-hold-twitter-bootstrap-popover-open-until-my-mouse-moves-into-it
  jQuery ->  
    $(".trip_title_main_text").popover(
      html: true
      offset: 10
      trigger: 'manual'
      placement: "bottom"
      title: "Title"
      template: '<div class="popover summary_text_popover_outside" onmouseover="$(this).mouseleave(function() {$(this).hide(); });"><div class="arrow"></div><div class="popover-inner summary_text_popover_inner"><div class="popover-content"><p></p></div></div></div>'
    ).mouseenter (e) ->
      $(this).popover "show"

) window.trips_namespace = window.trips_namespace or {}, jQuery