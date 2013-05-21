((trips_namespace, $, undefined_) ->

  jQuery ->
    #jQuery Validate Rules for the Add Activity Form in the Publish Trip Form
    trips_namespace.pubLocationPlace_rule =
      required: true

    trips_namespace.pubUserDescription_rule = 
      required: true
      maxlength: 200
        
    trips_namespace.pubQuickTip_rule =
      required: false      
      maxlength: 140
    
    trips_namespace.pubVenueId_rule =
      required: true

    trips_namespace.pubDuration_rule =
      required: true
      min: 1

    trips_namespace.pubLocationPlace_message = "Please select a Location"

    trips_namespace.pubUserDescription_message = "Please enter a Description with less than 200 characters"
    
    trips_namespace.pubQuickTip_message = "Please enter a Quick Tip with less than 140 characters"

    trips_namespace.pubVenueId_message = "Please select a Venue"

    trips_namespace.pubDuration_message = "Please select a Duration"

    #jQuery Validate Rules for the Publish Confirm Form
    trips_namespace.pubFormCreateRules = 
      ignore: []  
      rules:
        "publish_place_dropdown_field": trips_namespace.pubLocationPlace_rule
        "trip[trip_name]": trips_namespace.pubTitle_rule
        "trip[trip_summary]": trips_namespace.pubUserDescription_rule
      messages:
        "publish_place_dropdown_field": trips_namespace.pubLocationPlace_message 
        "trip[trip_name]": "Please enter a Trip Title with fewer than 40 characters"
        "trip[trip_summary]": "Please enter a Summary with fewer than 200 characters"
      success: (label, element) ->
        return
      showErrors: (errorMap, errorList) ->
        summary = ""
        $.each errorList, ->
          summary += " * " + @message + "</br>"
        if summary != ""
          $(".error_msg").html summary
        else
          $(".error_msg").empty
      onfocusout: false
      onkeyup: false
      onclick: false

      
    trips_namespace.pubFormAddActivityRules = 
      ignore: [] 
      rules:
        description: trips_namespace.pubUserDescription_rule
        quick_tip: trips_namespace.pubQuickTip_rule
        venueid: trips_namespace.pubVenueId_rule
        duration: trips_namespace.pubDuration_rule
      messages: 
        description: trips_namespace.pubUserDescription_message
        quick_tip: trips_namespace.pubQuickTip_message
        venueid: trips_namespace.pubVenueId_message
        duration: trips_namespace.pubDuration_message
      success: (label, element) ->
        return
      showErrors: (errorMap, errorList) ->
        summary = ""
        $.each errorList, ->
          summary += " * " + @message + "</br>"
        if summary != ""
          $(".error_msg").html summary
        else
          $(".error_msg").empty
      onfocusout: false
      onkeyup: false
      onclick: false

    trips_namespace.pubTitle_rule =
      required: true      
      maxlength: 40

    #jQuery Validate Rules for the Publish Confirm Form
    trips_namespace.pubFormConfirmRules = 
      ignore: []  
      rules:
        "trip[trip_name]": trips_namespace.pubTitle_rule
        "trip[trip_summary]": trips_namespace.pubUserDescription_rule
      messages: 
        "trip[trip_name]": "Please enter a Trip Title with fewer than 40 characters"
        "trip[trip_summary]": "Please enter a Summary with fewer than 200 characters"
      success: (label, element) ->
        return
      showErrors: (errorMap, errorList) ->
        summary = ""
        $.each errorList, ->
          summary += " * " + @message + "</br>"
        if summary != ""
          $(".error_msg").html summary
        else
          $(".error_msg").empty
      onfocusout: false
      onkeyup: false
      onclick: false

    $(".pt_confirm_form").validate(trips_namespace.pubFormConfirmRules);
    $("#new_trip").validate(trips_namespace.pubFormCreateRules);
    
) window.trips_namespace = window.trips_namespace or {}, jQuery