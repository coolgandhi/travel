((site_wide_namespace, $, undefined_) ->
  site_wide_namespace.isMobile =

    Android: ->
      navigator.userAgent.match /Mobile Android/i

    BlackBerry: ->
      navigator.userAgent.match /BlackBerry/i

    iPhone: ->
      IS_IPAD = navigator.userAgent.match(/iPad/i);
      IS_IPHONE = (navigator.userAgent.match(/iPhone/i)) or (navigator.userAgent.match(/iPod/i));
      IS_IPHONE = false if IS_IPAD;
      IS_IPHONE

    Opera: ->
      navigator.userAgent.match /Opera Mini/i

    Windows: ->
      navigator.userAgent.match /IEMobile/i

    any: ->
      site_wide_namespace.isMobile.Android() or site_wide_namespace.isMobile.BlackBerry() or site_wide_namespace.isMobile.iPhone() or site_wide_namespace.isMobile.Opera() or site_wide_namespace.isMobile.Windows()


  jQuery ->
    if site_wide_namespace.isMobile.any()
      height = $(window).height()
      width = $(window).width()
      if(width < height) 	      
        $('#warning-message').show()

    $(window).bind "resize", (e) ->
      if site_wide_namespace.isMobile.any()  
        height = $(window).height()
        width = $(window).width()
        if(width < height) 	      
          $('#warning-message').show()
        else
          $('#warning-message').hide()
      
) window.site_wide_namespace = window.site_wide_namespace or {}, jQuery