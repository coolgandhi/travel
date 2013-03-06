((trips_namespace, $, undefined_) ->

  $ ->  
    $("#trips-results-container").on "click", ".pagination a", (e) ->
      $.getScript this.href, ->
        try
          FB.XFBML.parse()
        return
      return false
 
    trips_namespace.searchformrules = 
      rules:
        days:
          required: false
          min: 1
      success: (label) ->
        $(".error-msg").empty()
        return
      errorPlacement: (error, element) ->
        $(".error-msg").empty()
        error.appendTo $(".error-msg")
        return
      onfocusout: (element) ->
        if ($(element).attr('id') == "days" or $(element).attr('id') == "results-day-field" or $(element).attr('id') == "dropdown-day-field") and $(element).val() == ""
          $(".error-msg").empty()
        else
          $(element).valid()
        return
    
    jQuery ->
      $(".hero-form").validate(trips_namespace.searchformrules)
      $(".droptoggle-form").validate(trips_namespace.searchformrules)

    $('#scrolltotop').on "click", null, (e) ->
      $("html, body").animate({
         scrollTop: 0
      }, "slow")
      $('#scrolltotop').fadeOut("slow")
      $('#scrolltotop').hide()
  
    if $('.pagination').length
      $(window).scroll ->
        $('.pagination').hide()
        url = $('.pagination .next_page').attr('href')
        if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
          $('.pagination').text('Fetching pins')
          $('.continuous-loading-indicator-wrapper').show()
          $.getScript(url).done ->
            $('.continuous-loading-indicator-wrapper').hide()
          return
        if $(window).scrollTop() > 0
          $('#scrolltotop').fadeIn("slow")
        else
          $('#scrolltotop').fadeOut("slow")
      # $(window).scroll()
    return
  
) window.trips_namespace = window.trips_namespace or {}, jQuery