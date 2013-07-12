((trips_namespace, $, undefined_) ->
  
  jQuery ->
    trips_namespace.fireUsefulButton = ->
      $("#useful_button").unbind("click").click ->
        $this = $(this)
        trips_namespace.closeOverviewModal();
        trips_activities_namespace.closeMapModal();
        $.ajax 
          url: $this.data('usefulurl')+'/'
          type: 'get'
          dataType: 'script'
          contentType: false
          processData: false
          complete: ->
            $(".useful_button").attr("disabled", true);
        if !Modernizr.touch and !site_wide_namespace.isMobile.any() 
          $('.trip_chalo_feedback_modal').modal('show')
    
    trips_namespace.fireSwipeViewUsefulButton = ->
      if ($("#useful_button").length and $("#useful_button").hasClass("disabled"))
        $(".trip_useful_message").html('');
        $(".useful_button").html "<i class=\"icon-heart\"></i>"
        $(".useful_button").addClass "disabled"
      else
        requestRunning = false;
        if requestRunning
          return
        requestRunning = true;
        $("#swipeview_useful_button").unbind("click").click ->
          $this2 = $(this)
          trips_namespace.closeOverviewModal();
          trips_activities_namespace.closeMapModal();
          $.ajax 
            url: $this2.data('usefulurl')+'/'
            type: 'get'
            dataType: 'script'
            contentType: false
            processData: false
            complete: ->
              $(".useful_button").unbind('click');
              $(".useful_button").attr("disabled", true);
              requestRunning = false;
          if !Modernizr.touch and !site_wide_namespace.isMobile.any()
            $('.trip_chalo_feedback_modal').modal('show')

    #fire fire fire!!!
    trips_namespace.fireUsefulButton();
    #close the modal on cancel click
    $('#feedback_cancel_button').click ->
      $('.trip_chalo_feedback_modal').modal('hide');

) window.trips_namespace = window.trips_namespace or {}, jQuery

