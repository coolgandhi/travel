((trips_namespace, $, undefined_) ->
  #http://stackoverflow.com/questions/7703878/how-can-i-hold-twitter-bootstrap-popover-open-until-my-mouse-moves-into-it
  jQuery ->  
    trips_namespace.fireAuthorPopOver = ->
      $(".author_intrip_popover").popover(
        html: true
        offset: 10
        trigger: 'manual'
        delay: { show: 350, hide: 100 }
        placement: "bottom"
        title: "Title"
        template: '<div class="popover author_popover_outside" onmouseover="$(this).mouseleave(function() {$(this).hide(); });"><div class="arrow"></div><div class="popover-inner author_popover_inner"><div class="popover-content"><p></p></div></div></div>'
      )

      hidePopover = (elem) ->
        $(elem).popover "hide"
      
      timer = undefined
      popover_parent = undefined
      
      $(".author_intrip_popover").hover (->
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

  jQuery ->
    trips_namespace.fireAuthorPopOver()
    
) window.trips_namespace = window.trips_namespace or {}, jQuery