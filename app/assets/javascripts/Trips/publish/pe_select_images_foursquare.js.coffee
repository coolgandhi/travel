((trips_activities_namespace, $, undefined_) ->
  
  totalSelectedImages = 0;
  
  trips_activities_namespace.make_venue_images_selectable = ->
    $(".pe_select_image_4SQ_modal img").click ->  
      if ($(this).hasClass('pe_selected_pic')) 
        $(this).removeClass('pe_selected_pic')
        totalSelectedImages--
      else 
        if totalSelectedImages == 5
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
      return true
    return


  jQuery ->
    trips_activities_namespace.populate_selected_images_field();
    $('.publish_trip_create_activities').on "click", ".ta_pick_from_foursquare", (e) ->
      e.preventDefault();
      $('.pe_select_image_4SQ_modal').modal('show');
      $(".select_image_spinner").show();
      foursquare_id = $('#venue_id').val();
      site_wide_namespace.fetchvenueimages(foursquare_id, $(".4SQ_images_select_div"));
      # trips_activities_namespace.make_venue_images_selectable();
      # trips_activities_namespace.populate_selected_images_field();
    
    $(".pe_select_image_4SQ_modal").on "show", (e) ->
    
    $(".pe_select_image_4SQ_modal").on "hide", (e) ->
      $(".4SQ_images_select_div").empty();
      totalSelectedImages = 0;

    #close the modal on click or on esc button key press
    $('#4SQ_cancel_button').click ->
      $('.pe_select_image_4SQ_modal').modal('hide');

    $(document).bind "keydown", (e) ->
      $('.pe_select_image_4SQ_modal').modal('hide') if e.which is 27
  
  #Select Cover Image
  jQuery ->
    trips_activities_namespace.populate_coverimages_field();
    $('.trip_cover_pick_foursquare_btn').click (e) ->
      e.preventDefault();
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