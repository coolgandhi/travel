# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

((trips_activities_namespace, $, undefined_) ->
  #this makes an ajax call to pull foursquare data given a foursquare ID and then change a div on front-end
  trips_activities_namespace.populate_venue_detail = (foursquare_id) ->
    $.ajax
      beforeSend: ->
        $(".confirm_box_spinner").show()
      url: window.location.protocol + "//" + window.location.host + "/venues/get_venue_details.json"
      dataType: "json"
      data: 
        venueid: foursquare_id
      complete: ->
        $(".confirm_box_spinner").hide()
      success: (data) ->
        $.map(data, (item) ->
          if item == null
            $('.publish_trip_confirm_name').html(
              "<strong>Something went wrong on our servers. Please try again in few minutes. Sorry!</strong>" 
            );
          else
            $('.publish_trip_confirm_name').html(
              "<strong><a href='" + item.canonicalUrl + "' target='_blank'>" + item.name + "</a></strong>" 
            );
            $('.publish_trip_confirm_category').html(item.category_name);
            secondAddress = if (!item.address2) then "" else ("</br>" + "(" + item.address2 + ")")
            $('.publish_trip_confirm_address').html(
              "<address>" + item.address1 + secondAddress +
              "</br>" + item.city + ", " + item.state + " " + item.zip + "</address>" 
            );
            $('.stats_checkins').html(
              item.venue_stats.checkinsCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") 
            ) if item.venue_stats != undefined
            $('.stats_rating').html(
              (Math.round( item.rating * 10 ) / 10) + " / 10"
            ) if item.rating != undefined
            $('.stats_rating_header').html('<strong>4sq Rating</strong>');
            $('.stats_checkins_header').html('<strong>Total Check-ins</strong>');
          )

  totalSelectedImages = 0;

  jQuery ->        
    $('#locationvenue').autocomplete
      minLength: 3
      source: (request, response) ->
        $.ajax
          url: window.location.protocol + "//" + window.location.host + "/venues/pick.json"
          dataType: "json"
          data: 
            total: 10
            ven: request.term
            latlong: $('#trip_activity_latlong').val()
          success: (data) ->
            response $.map(data, (item) ->
              $('#location_activity_location_detail_id').val(item.value)
              label: item.label + ", " + item.address + ", " + item.city
              value: item.value
              )
      open: ->
        $(this).removeClass("#locationvenue").addClass "ui-corner-top"
      close: ->
        $(this).removeClass("ui-corner-top").addClass "ui-corner-all"
      focus: (event, ui) ->
        event.preventDefault()
        $(this).val ui.item.label      
      select: (event, ui) ->
        event.preventDefault()
        $('#location_activity_location_detail_id').val( ui.item.value )
        $(this).val ui.item.label
        $(this).siblings('#locationvenue').val ui.item.value
        site_wide_namespace.fetchvenueimages ui.item.value, $("#venue_images")

  jQuery ->        
    $('#foodvenue').autocomplete
      minLength: 3
      source: (request, response) ->
        $.ajax 
          url: window.location.protocol + "//" + window.location.host + "/venues/pick.json"
          dataType: "json"
          data: 
            total: 10
            ven: request.term
            latlong: $('#trip_activity_latlong').val()
          success: (data) ->
            response $.map(data, (item) ->
              $('#food_activity_restaurant_detail_id').val(item.value)
              label: item.label + ", " + item.address + ", " + item.city
              value: item.value
              )
      open: ->
        $(this).removeClass("#foodvenue").addClass "ui-corner-top"
      close: ->
        $(this).removeClass("ui-corner-top").addClass "ui-corner-all"
      focus: (event, ui) ->
        event.preventDefault()
        $(this).val ui.item.label      
      select: (event, ui) ->
        event.preventDefault()
        $('#food_activity_restaurant_detail_id').val( ui.item.value )
        $(this).val ui.item.label
        $(this).siblings('#foodvenue').val ui.item.value   
        site_wide_namespace.fetchvenueimages ui.item.value, $("#venue_images")
  
      
  jQuery ->
    $('.publish_trip_create_activities').on "focus", "input", ->
      $('#activityvenue').autocomplete
        minLength: 3
        source: (request, response) ->
          $('#venue_id').val('')      
          $('.publish_trip_confirm_name').html('')
          $('.publish_trip_confirm_category').html('');
          $('.publish_trip_confirm_address').html('')
          $('.stats_checkins').html('')
          $('.stats_rating').html('')
          $('.stats_rating_header').html('')
          $('.stats_checkins_header').html('')
          $.ajax 
            url: window.location.protocol + "//" + window.location.host + "/venues/pick.json"
            dataType: "json"
            data: 
              total: 20
              ven: request.term
              latlong: $('#trip_activity_latlong').val()
            success: (data) ->
              if data != null
                response $.map(data, (item) ->
                  if item != null
                    $('#venue_id').val(item.value)
                    label: item.label + ", " + item.address + ", " + item.city
                    value: item.value
                  else
                    location = $('#place_dropdown').val()
                    $('#place_dropdown').val("Search for this activity in a different city? Please Enter the city name here.")
                )
                if jQuery.isEmptyObject(data)
                  present_block = $("#no_activity_warning").css("display")
                  if present_block != "block"
                    $("#no_activity_warning").css({ "display": "block", "opacity": "0" }).animate({ "opacity": "1" }, 2000)
              else
                $('.publish_trip_confirm_name').html(
                  "<strong>Something went wrong on our servers. Please try again in few minutes. Sorry!</strong>" 
                )
        open: ->
          $(this).removeClass("#activityvenue").addClass "ui-corner-top"
        close: ->
          $(this).removeClass("ui-corner-top").addClass "ui-corner-all"
        focus: (event, ui) ->
          event.preventDefault()
          $(this).val ui.item.label      
        select: (event, ui) ->
          event.preventDefault()
          if ui.item == null
            $('.publish_trip_confirm_name').html(
              "<strong>Something went wrong on our servers. Please try this request once again after 5 minutes. Sorry!</strong>" 
            );
          else
            $('#venue_id').val( ui.item.value )
            $(this).val ui.item.label
            $(this).siblings('#activityvenue').val ui.item.value
            trips_activities_namespace.populate_venue_detail (ui.item.value)   
  

  jQuery ->
    $(".publish_trip_create_activities").on "click", ".close", (e) ->  
      $("#no_activity_warning").css({ "display": "none"})  


  jQuery ->
    $("#venue_images").on "click", "img", (e) ->
      if ($(this).css("borderWidth") == '5px') 
        $(this).css("border",'1px solid black')
        totalSelectedImages--
      else 
        if totalSelectedImages == 5
          alert "5 images selected already, unselect one"
        else
          $(this).css("border",'5px solid blue')
          totalSelectedImages++
      return
    return



  jQuery ->
    $("#trip_activities_form_submit").click ->
      console.log "here"
      dat = ""
      $.each $('#venue_images').children(), (index, data) ->
        if ($(this).css("borderWidth") == '5px')
          da = $(this).data('img')
          dat = dat + da.img + ";"
          return
      $('#selected_images').val(dat)    
      return true
    return
     
) window.trips_activities_namespace = window.trips_activities_namespace or {}, jQuery