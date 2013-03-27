((trips_namespace, $, undefined_) ->

  $ ->  
    $("#trips_results_container").on "click", ".pagination a", (e) ->  
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
      
    trips_namespace.day_err_message = "Please enter at least 1 day for the trip"
    
    trips_namespace.place_err_message = "Please select where would you like to go"
      
    trips_namespace.searchformrules_on_page_box = 
      rules:
        days: trips_namespace.day_rule
        place_dropdown_field: trips_namespace.place_rule
      messages: 
        days: trips_namespace.day_err_message
        place_dropdown_field: trips_namespace.place_err_message
      success: (label, element) ->
        # $(element).parents('form').siblings(".error_msg").empty()
        return
      showErrors: (errorMap, errorList) ->
        summary = ""
        $.each errorList, ->
          summary += " * " + @message + "\n"
        if summary != ""
          $(".error_msg").html summary
        else
          $(".error_msg").empty
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
        # $(element).parents('form').siblings(".error_msg").empty()
        return
      showErrors: (errorMap, errorList) ->
        summary = ""
        $.each errorList, ->
          summary += " * " + @message + "\n"
          return
        console.log summary
        if summary != ""
          $(".small_error_msg").html summary
          return
        else
          $(".small_error_msg").empty
          return
      onfocusout: false
      onkeyup: false
      onclick: false
    
    
    jQuery ->
      $(".hero_form").validate(trips_namespace.searchformrules_on_page_box)
      $(".droptoggle_form").validate(trips_namespace.searchformrules_small_box)
      $(".hero_form").submit ->
        # alert $("#place_dropdown_field").val() + " " + $("#traveler_type_id").val() + " " + $("#from-datefield").val() + " " + $("#days").val()
        site_wide_namespace.setCustomVar(1, "place", $("#place_dropdown_field").val().toString(), 3) if $("#place_dropdown_field").val() != null and $("#place_dropdown_field").val() != ""
        site_wide_namespace.setCustomVar(2, "traveler_type", $("#traveler_type_id").val().toString(), 3) if $("#traveler_type_id").val() != null and $("#traveler_type_id").val() != ""
        site_wide_namespace.setCustomVar(3, "start_date", $("#from-datefield").val().toString(), 3) if $("#from-datefield").val() != null and $("#from-datefield").val() != ""
        site_wide_namespace.setCustomVar(4, "number_of_days", $("#days").val().toString(), 3) if $("#days").val() != null and $("#days").val() != ""
        site_wide_namespace.trackEvent("search", "click", "big_box")
        #console.log ($("#place_dropdown_field").val())
        return true
      $(".droptoggle_form").submit -> 
        # alert $("#droptoggle_searchbar_id").val() + " " + $("#dropdown_traveler_type_id").val() + " " + $("#dropdown-from-datefield").val() + " " + $("#dropdown_day_field").val() 
        site_wide_namespace.setCustomVar(1, "place", $("#droptoggle_searchbar_id").val().toString(), 3) if $("#droptoggle_searchbar_id").val() != null and $("#droptoggle_searchbar_id").val() != "" 
        site_wide_namespace.setCustomVar(2, "traveler_type", $("#dropdown_traveler_type_id").val().toString(), 3) if $("#dropdown_traveler_type_id").val() != null and $("#dropdown_traveler_type_id").val() != ""
        site_wide_namespace.setCustomVar(3, "start_date", $("#dropdown-from-datefield").val().toString(), 3)  if $("#dropdown-from-datefield").val() != null and $("#dropdown-from-datefield").val() != ""
        site_wide_namespace.setCustomVar(4, "number_of_days", $("#dropdown-day-field").val().toString(), 3) if $("#dropdown-day-field").val() != null and $("#dropdown-day-field").val() != ""
        site_wide_namespace.trackEvent("search", "click", "small_box")
        return true
      $(".results_hero_form").validate trips_namespace.searchformrules_on_page_box
      $(".results_hero_form").submit ->
        #      #alert ($("#place_dropdown_field").val() + " " + $("#results_traveler_type_id").val() + " " + $("#from").val() + " " + $("#results_day_field").val());
        site_wide_namespace.setCustomVar(1, "place", $("#place_dropdown_field").val().toString(), 3) if $("#place_dropdown_field").val() != null and $("#place_dropdown_field").val() != ""
        site_wide_namespace.setCustomVar(2, "traveler_type", $("#results_traveler_type_id").val().toString(), 3) if $("#results_traveler_type_id").val() != null and $("#results_traveler_type_id").val() != ""
        site_wide_namespace.setCustomVar(3, "start_date", $("#from").val().toString(), 3) if $("#from").val() != null and $("#from").val() != ""
        site_wide_namespace.setCustomVar(4, "number_of_days", $("#results_day_field").val().toString(), 3) if $("#results_day_field").val() != null and $("#results_day_field").val() != ""
        site_wide_namespace.trackEvent "search", "click", "results_search_box"
        return true
      return
    
    trips_namespace.continuousScrollPagination = ->
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
            $('.continuous_loading_indicator_wrapper').show()
            $.getScript(url).done ->
              $('.continuous_loading_indicator_wrapper').hide()
              # history.pushState {state:1}, document.title, url
            return
          if $(window).scrollTop() > 0
            $('#scrolltotop').fadeIn("slow")
          else
            $('#scrolltotop').fadeOut("slow")
        $(window).scroll()
      return

    jQuery ->    
      trips_namespace.continuousScrollPagination()

  trips_namespace.remoteLoadIndexFire = ->
    trips_namespace.fireResultSearchBarJs()
    trips_namespace.continuousScrollPagination()
    $(".results_hero_form").validate trips_namespace.searchformrules_on_page_box
    $(".droptoggle_menu").hide()
    $(".results_hero_form").on "submit", ->
      #      #alert ($("#place_dropdown_field").val() + " " + $("#results_traveler_type_id").val() + " " + $("#from").val() + " " + $("#results_day_field").val());
      site_wide_namespace.setCustomVar(1, "place", $("#place_dropdown_field").val().toString(), 3) if $("#place_dropdown_field").val() != null and $("#place_dropdown_field").val() != ""
      site_wide_namespace.setCustomVar(2, "traveler_type", $("#results_traveler_type_id").val().toString(), 3) if $("#results_traveler_type_id").val() != null and $("#results_traveler_type_id").val() != ""
      site_wide_namespace.setCustomVar(3, "start_date", $("#from").val().toString(), 3) if $("#from").val() != null and $("#from").val() != ""
      site_wide_namespace.setCustomVar(4, "number_of_days", $("#results_day_field").val().toString(), 3) if $("#results_day_field").val() != null and $("#results_day_field").val() != ""
      site_wide_namespace.trackEvent "search", "click", "results_search_box"
      return true
    return
  
) window.trips_namespace = window.trips_namespace or {}, jQuery