((trips_namespace, $, undefined_) ->

  $ ->
    $(".middle_results_container").on "click", ".trip_result_thumbnail_div a", (e) ->
      #alert ("hello_pushstate" + $(this).parents('.trip_result_thumbnail_div').find('#request_uri_hidden').val())
      unless $('.featured_results_title').length > 0
        history.pushState {first: $(this).parents('.trip_result_thumbnail_div').find('#request_uri_hidden').val()}, "", location.url
      #console.log($(this).parent('.trip_result_thumbnail_div').find('#request_uri_hidden').val())

    $(window).on "popstate", (e) ->
      # alert ('hi_popstate_outside' + history.state.first)
      if (history.state && typeof history.state.first != 'undefined' )
        #alert ('hello_popstate' +  history.state.first)
        #console.log('hello_popsatte' +  history.state.first)  
        $.getScript(history.state.first)
        history.replaceState {initial: location.url},"",location.url

) window.trips_namespace = window.trips_namespace or {}, jQuery