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
    
    $(".hero-form").submit ->
      site_wide_namespace.setCustomVar(1, "place", $("#place_dropdown_field").val(), 3) 
      site_wide_namespace.setCustomVar(2, "traveler_type", $("#traveler_type_id").val(), 3) 
      site_wide_namespace.setCustomVar(3, "start_date", $("#from-datefield").val(), 3) 
      site_wide_namespace.setCustomVar(4, "number_of_days", $("#days").val(), 3) 
      site_wide_namespace.trackEvent("search", "click", "big_box")
      return
      
    $(".droptoggle-form").submit -> 
      site_wide_namespace.setCustomVar(1, "place", $("#droptoggle_searchbar_id").val(), 3) 
      site_wide_namespace.setCustomVar(2, "traveler_type", $("#dropdown_traveler_type_id").val(), 3) 
      site_wide_namespace.setCustomVar(3, "start_date", $("#dropdown-from-datefield").val(), 3) 
      site_wide_namespace.setCustomVar(4, "number_of_days", $("#days").val(), 3) 
      site_wide_namespace.trackEvent("search", "click", "small_box")
      return
    

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