((site_wide_namespace, $, undefined_) ->

  site_wide_namespace.trackEvent = (category, action, label = null, value = null, noninteraction = false) ->
      _gaq.push(['_trackEvent', category, action, label, value, noninteraction]) 
      return
    
  site_wide_namespace.trackPageview = (pageURL = null) ->
      _gaq.push(['_trackPageview', pageURL])
      return

  site_wide_namespace.trackSocial = (network, action, target = null, page = null) ->
      _gaq.push(['_trackSocial', network, action, target, page])
      return

  site_wide_namespace.disable_tracking = () ->
    window['ga-disable-UA-39026127-1'] = true
    return

  site_wide_namespace.enable_tracking = () ->
    window['ga-disable-UA-39026127-1'] = false
    return
    
  site_wide_namespace.setCustomVar = (index, name, value, scope) ->
    console.log (index + " " + name + " " + value + " " + scope)
    _gaq.push(['_setCustomVar', index, name, value, scope])   
    return
    
  jQuery ->
      $("#homepagelink").unbind("click").click -> 
        site_wide_namespace.trackEvent("home", "click", document.URL)
        return
      $("#aboutlink").unbind("click").click -> 
        site_wide_namespace.trackEvent("about", "click", document.URL)
        return
      return
    return
    
  
) window.site_wide_namespace = window.site_wide_namespace or {}, jQuery



