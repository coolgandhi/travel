# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

((trips_activities_namespace, $, undefined_) ->

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
        # console.log(foursquare_id)
        $.map(data, (item) ->
          $('.publish_trip_confirm_name').html(
            "<strong><a href='" + item.canonicalUrl + "' target='_blank'>" + item.name + "</a></strong>" 
          );
          $('.publish_trip_confirm_category').html(item.category_name);
          $('.publish_trip_confirm_address').html(
            "<address>" + item.address1 + "</br>" + "(" + item.address2 + ")" +
            "</br>" + item.city + ", " + item.state + " " + item.zip + "</address>" 
          );
          $('.publish_trip_confirm_stats').html();
          $('.stats_checkins').html(
            item.venue_stats.checkinsCount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")
          );
          $('.stats_rating').html(
            (Math.round( item.rating * 10 ) / 10) + " / 10"
          );
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
          $.ajax 
            url: window.location.protocol + "//" + window.location.host + "/venues/pick.json"
            dataType: "json"
            data: 
              total: 10
              ven: request.term
              latlong: $('#trip_activity_latlong').val()
            success: (data) ->
              response $.map(data, (item) ->
                $('#venue_id').val(item.value)
                label: item.label + ", " + item.address + ", " + item.city
                value: item.value
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
          $('#venue_id').val( ui.item.value )
          $(this).val ui.item.label
          $(this).siblings('#activityvenue').val ui.item.value
          trips_activities_namespace.populate_venue_detail (ui.item.value)   
      
          
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