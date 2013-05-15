((infocontroller_namespace, $, undefined_) ->
  
  infocontroller_namespace.fireNavPillsActive = ->
    $(".pill_make_active").click (e) ->
      e.preventDefault()
      full_url = this.href
      parts = full_url.split("#")
      trgt = parts[1]
      target_offset = $("#" + trgt).offset()
      target_top = target_offset.top
      $("html, body").animate
        scrollTop: target_top
      , 500
      # Remove active class on any li when an anchor is clicked 
      $('.nav_pill_parent').children().removeClass("active")  
      # Add active class to clicked anchor's parent li 
      # $(this).parent().addClass "active"
  
  jQuery ->
    infocontroller_namespace.fireNavPillsActive();

) window.infocontroller_namespace = window.infocontroller_namespace or {}, jQuery



