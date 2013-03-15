((site_wide_namespace, $, undefined_) ->
  isMobile =
    Android: ->
      navigator.userAgent.match /Android/i

    BlackBerry: ->
      navigator.userAgent.match /BlackBerry/i

    iOS: ->
      navigator.userAgent.match /iPhone|iPod/i

    Opera: ->
      navigator.userAgent.match /Opera Mini/i

    Windows: ->
      navigator.userAgent.match /IEMobile/i

    any: ->
      isMobile.Android() or isMobile.BlackBerry() or isMobile.iOS() or isMobile.Opera() or isMobile.Windows()

  jQuery -> 
    $('body').prepend('<div class = "mobile_disclaimer_prepend">Please visit us on a desktop or tablet device. We are hard at work to support this device.</div>') if isMobile.any()

) window.site_wide_namespace = window.site_wide_namespace or {}, jQuery