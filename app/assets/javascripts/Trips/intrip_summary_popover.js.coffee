((trips_namespace, $, undefined_) ->
  #http://stackoverflow.com/questions/7703878/how-can-i-hold-twitter-bootstrap-popover-open-until-my-mouse-moves-into-it
  jQuery ->  
    $(".trip_title_main_text").popover(
      html: true
      offset: 10
      trigger: 'manual'
      delay: { show: 350, hide: 100 }
      placement: "bottom"
      title: "Title"
      template: '<div class="popover summary_text_popover_outside" onmouseover="$(this).mouseleave(function() {$(this).hide(); });"><div class="arrow"></div><div class="popover-inner summary_text_popover_inner"><div class="popover-content"><p></p></div></div></div>'
    )

    hidePopover = (elem) ->
      $(elem).popover "hide"
    
    timer = undefined
    popover_parent = undefined
    
    $(".trip_title_main_text").hover (->
      self = this
      clearTimeout timer
      $(".popover").hide() #Hide any open popovers on other elements.
      popover_parent = self
      $(self).popover "show"
    ), ->
      self = this
      timer = setTimeout(->
        hidePopover self
      , 300)

    $(document).on
      mouseenter: ->
        clearTimeout timer

      mouseleave: ->
        self = this
        timer = setTimeout(->
          hidePopover popover_parent
        , 300)
    , ".popover"

) window.trips_namespace = window.trips_namespace or {}, jQuery