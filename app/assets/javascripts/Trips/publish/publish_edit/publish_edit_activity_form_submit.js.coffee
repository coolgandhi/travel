((trips_namespace, $, undefined_) ->
  
  jQuery ->
    $('.publish_trip_create_activities').on "click", "#trip_activity_form_button", ->
      $("#trip_activity_name").val($("#activityvenue").val())
      formData = new FormData($('.publish_trip_create_activities form')[0])
      if $(".pt_trip_activity_form").valid(trips_namespace.pubFormAddActivityRules) == true
        $.ajax
          beforeSend: ->
            $('.trip_activity_form_mask').fadeIn('slow');
          url: $('.publish_trip_create_activities form').attr('action')
          type: $('.publish_trip_create_activities form').attr('method')
          data: formData
          dataType: 'script'
          contentType: false
          processData: false
          complete: ->
            $('.trip_activity_form_mask').fadeOut('slow');
      else
        e.preventDefault();     
      return

) window.trips_namespace = window.trips_namespace or {}, jQuery

