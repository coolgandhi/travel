((trips_namespace, $, undefined_) ->

  $ ->  
    $("#trips-results-container").on "click", ".pagination a", (e) ->
      $.getScript this.href, ->
        try
          FB.XFBML.parse()
        return
      return false
 
    trips_namespace.day_rule = 
      required: false
      min: 1
        
    trips_namespace.place_rule =
      required: true      
      
    trips_namespace.day_err_message = "Please enter atleast 1 day for the trip"
    
    trips_namespace.place_err_message = "Please select where would you like to go"
      
    trips_namespace.searchformrules_on_page_box = 
      rules:
        days: trips_namespace.day_rule
        place_dropdown_field: trips_namespace.place_rule
      messages: 
        days: trips_namespace.day_err_message
        place_dropdown_field: trips_namespace.place_err_message
      success: (label, element) ->
        # $(element).parents('form').siblings(".error-msg").empty()
        return
      showErrors: (errorMap, errorList) ->
        summary = ""
        $.each errorList, ->
          summary += " * " + @message + "\n"
        if summary != ""
          $(".error-msg").html summary
        else
          $(".error-msg").empty
      onfocusout: false
      onkeyup: false
      onclick: false
      
    trips_namespace.searchformrules_small_box = 
      ignore: []
      rules:
        days: trips_namespace.day_rule
        place_text_field: trips_namespace.place_rule
      messages: 
        days: trips_namespace.day_err_message
        place_text_field: trips_namespace.place_err_message
      success: (label, element) ->
        # $(element).parents('form').siblings(".error-msg").empty()
        return
      showErrors: (errorMap, errorList) ->
        summary = ""
        $.each errorList, ->
          summary += " * " + @message + "\n"
          return
        console.log summary
        if summary != ""
          $(".small-error-msg").html summary
          return
        else
          $(".small-error-msg").empty
          return
      onfocusout: false
      onkeyup: false
      onclick: false
    
    
    jQuery ->
      $(".hero-form").validate(trips_namespace.searchformrules_on_page_box)
      $(".droptoggle-form").validate(trips_namespace.searchformrules_small_box)
      $(".hero-form").submit ->
        # alert $("#place_dropdown_field").val() + " " + $("#traveler_type_id").val() + " " + $("#from-datefield").val() + " " + $("#days").val()
        site_wide_namespace.setCustomVar(1, "place", $("#place_dropdown_field").val(), 3) 
        site_wide_namespace.setCustomVar(2, "traveler_type", $("#traveler_type_id").val(), 3) 
        site_wide_namespace.setCustomVar(3, "start_date", $("#from-datefield").val(), 3) 
        site_wide_namespace.setCustomVar(4, "number_of_days", $("#days").val(), 3) 
        site_wide_namespace.trackEvent("search", "click", "big_box")
        return
      $(".droptoggle-form").submit -> 
        # alert $("#droptoggle_searchbar_id").val() + " " + $("#dropdown_traveler_type_id").val() + " " + $("#dropdown-from-datefield").val() + " " + $("#dropdown_day_field").val()
        site_wide_namespace.setCustomVar(1, "place", $("#droptoggle_searchbar_id").val(), 3) 
        site_wide_namespace.setCustomVar(2, "traveler_type", $("#dropdown_traveler_type_id").val(), 3) 
        site_wide_namespace.setCustomVar(3, "start_date", $("#dropdown-from-datefield").val(), 3) 
        site_wide_namespace.setCustomVar(4, "number_of_days", $("#dropdown_day_field").val(), 3) 
        site_wide_namespace.trackEvent("search", "click", "small_box")
        return
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