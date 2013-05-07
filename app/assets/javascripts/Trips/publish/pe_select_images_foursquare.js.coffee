((trips_activities_namespace, $, undefined_) ->
  
  totalSelectedImages = 0;
  
  trips_activities_namespace.make_venue_images_selectable = ->
    $(".pe_select_image_4SQ_modal img").click ->  
      if ($(this).hasClass('pe_selected_pic')) 
        $(this).removeClass('pe_selected_pic')
        totalSelectedImages--
      else 
        if totalSelectedImages == 1
          alert "Max number of images selected."
        else
          $(this).addClass('pe_selected_pic')
          totalSelectedImages++
      return
    return

  trips_activities_namespace.populate_selected_images_field = ->
    $("#4SQ_select_button").click ->
      dat = ""
      $.each $(".4SQ_images_select_div").children('img'), (index, data) ->
        if ($(this).hasClass('pe_selected_pic'))
          da = $(this).data('img')
          dat = dat + da.img + ";"
          return
      $('#ta_selected_images_field').val(dat);
      $('.pe_select_image_4SQ_modal').modal('hide');
      # change foursquare image select button on select
      if $('#ta_selected_images_field').val().length > 1
        $('.ta_pick_from_foursquare').html('Foursquare Image Selected')
        $('.ta_pick_from_foursquare').removeClass("btn-flat-info").addClass("btn-flat-success")
      else
        $('.ta_pick_from_foursquare').html('Select From Foursquare')
        $('.ta_pick_from_foursquare').removeClass("btn-flat-success").addClass("btn-flat-info")
      return true
    return

  trips_activities_namespace.make_cover_images_selectable = ->
    $(".cover_select_modal img").click ->  
      if ($(this).hasClass('pe_selected_pic')) 
        $(this).removeClass('pe_selected_pic')
        totalSelectedImages--
      else 
        if totalSelectedImages == 1
          alert "Max number of images selected."
        else
          $(this).addClass('pe_selected_pic')
          totalSelectedImages++
      return
    return

  trips_activities_namespace.populate_coverimages_field = ->
    $("#cover_select_image_button").click ->
      dat = ""
      $.each $(".cover_images_select_div").children('img'), (index, data) ->
        if ($(this).hasClass('pe_selected_pic'))
          da = $(this).data('img')
          dat = dat + da.img + ";"
          return
      $('.selected_images').val(dat);
      $('.cover_select_modal').modal('hide');
      # change the foursquare selected button if images selected
      if $('.selected_images').val().length > 1
        $('.trip_cover_pick_foursquare_btn').html('Foursquare Image Selected')
        $('.trip_cover_pick_foursquare_btn').removeClass("btn-flat-info").addClass("btn-flat-success")
      else
        $('.trip_cover_pick_foursquare_btn').html('Select From Foursquare')
        $('.trip_cover_pick_foursquare_btn').removeClass("btn-flat-success").addClass("btn-flat-info")
      return true
    return

  trips_activities_namespace.activityimage_btn_tooltip = ->
    $('.ta_pick_from_foursquare').tooltip
      placement: "bottom"
      title: "Please enter an Activity Venue"
      trigger: "click"


  trips_activities_namespace.coverimage_btn_tooltip = ->
    $('.trip_cover_pick_foursquare_btn').tooltip
      placement: "bottom"
      title: "Please enter a City for this Trip"
      trigger: "click"

  jQuery ->
    trips_activities_namespace.populate_selected_images_field();
    $('.publish_trip_create_activities').on "click", ".ta_pick_from_foursquare", (e) ->
      e.preventDefault();
      unless $('#venue_id').val() is ""
        $('.pe_select_image_4SQ_modal').modal('show');
        $(".select_image_spinner").show();
        foursquare_id = $('#venue_id').val();
        site_wide_namespace.fetchvenueimages(foursquare_id, $(".4SQ_images_select_div"));
    
    $(".pe_select_image_4SQ_modal").on "hide", (e) ->
      $(".4SQ_images_select_div").empty();
      totalSelectedImages = 0;

    #close the modal on click or on esc button key press
    $('#4SQ_cancel_button').click ->
      $('.pe_select_image_4SQ_modal').modal('hide');

    $(document).bind "keydown", (e) ->
      $('.pe_select_image_4SQ_modal').modal('hide') if e.which is 27
    
    #change the foursquare select image button when images have been selected  
    $('#ta_selected_images_field').change ->
      if $('#ta_selected_images_field').val().length > 1
        $('.ta_pick_from_foursquare').html('Foursquare Images Selected')
        $('.ta_pick_from_foursquare').removeClass("btn-flat-info").addClass("btn-flat-primary")
      else 
        $('.ta_pick_from_foursquare').html('Select From Foursquare')
        $('.ta_pick_from_foursquare').removeClass("btn-flat-primary").addClass("btn-flat-info")
      
  #Select Cover Image
  jQuery ->
    trips_activities_namespace.populate_coverimages_field();
    trips_activities_namespace.coverimage_btn_tooltip() if $('#locationval').val() is ""
    $('.trip_cover_pick_foursquare_btn').mouseout ->
      $('.trip_cover_pick_foursquare_btn').tooltip('hide')

    $('.trip_cover_pick_foursquare_btn').click (e) ->
      e.preventDefault();
      unless $('#locationval').val() is ""
        $('.cover_select_modal').modal('show');
        $(".select_cover_image_spinner").show();
        place = $('#locationval').val().split(",")[0];
        latlong = $('#latlong').val();
        lat = latlong.split(",")[0]
        long = latlong.split(",")[1]
        site_wide_namespace.fetchlocationimages(place, lat, long, $(".cover_images_select_div"))

    $(".cover_select_modal").on "hide", (e) ->
      $(".cover_images_select_div").empty();
      totalSelectedImages = 0;

    #close the modal on click or on esc button key press
    $('#cover_select_cancel_button').click ->
      $('.cover_select_modal').modal('hide');

    $(document).bind "keydown", (e) ->
      $('.cover_select_modal').modal('hide') if e.which is 27

) window.trips_activities_namespace = window.trips_activities_namespace or {}, jQuery