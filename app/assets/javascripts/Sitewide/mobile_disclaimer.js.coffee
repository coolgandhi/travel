((site_wide_namespace, $, undefined_) ->
  isMobile =

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
      isMobile.Android() or isMobile.BlackBerry() or isMobile.iPhone() or isMobile.Opera() or isMobile.Windows()


  jQuery ->
    if isMobile.any()
      height = $(window).height()
      width = $(window).width()
      if(width < height) 	      
        $('#warning-message').show()
        $('.container').hide()

    $(window).bind "resize", (e) ->
      if isMobile.any()  
        height = $(window).height()
        width = $(window).width()
        if(width < height) 	      
          $('#warning-message').show()
          $('.container').hide()
        else
          $('#warning-message').hide()
          $('.container').show()
      
) window.site_wide_namespace = window.site_wide_namespace or {}, jQuery