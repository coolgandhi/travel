((trips_namespace, $, undefined_) ->
  # History = window.History;
  # origTitle = document.title;
  # history.navigationMode = 'compatible'

  # if history and history.pushState
  #   $ ->
  #     # History.pushState({state:$(this).attr('data-state'),leftcol:$('.middle_results_container').html()}, origTitle, $(this).attr("href"))
  #     # $('.middle_results_container, .splash_form_container').on "click", "a", (e) ->
  #     console.log('push this state dog')  
  #     history.pushState
  #       state: $(this).attr("data-state")
  #       leftcol: $(".middle_results_container").html()
  #     , origTitle, $(this).attr("href") 

  #     updateContent = (data) ->
  #       return  unless data? # check if null (can be triggered by Chrome on page load)
  #       $('.middle_results_container').html(data) # replace left col with new (or old from history) data
  #       console.log('yo yo')
  #       history.pushState # save this state to browser history
  #         state: $(this).attr("data-state")
  #         leftcol: $('.middle_results_container').html()
  #       , origTitle, $(this).attr("href")

  #     # History.Adapter.bind window, "statechange", -> # use this NOT popstate (history.JS)
  #     #   console.log('going back now')
  #     #   State = History.getState()
  #     #   updateContent(State.data.leftcol)

  #     window.addEventListener "popstate", (event) ->
  #       console.log('going back yo')
  #       State = History.getState()
  #       updateContent(State.data.leftcol)

  # trips_namespace.isInitialPageLoad = true;
  # $ ->
  #   $(".splash_form_container .splash_submit_button").click ->
  #     history.replaceState {midcon: $('.middle_results_container').html(), herocon: $('.big_image_header').length }, document.title, location.url
    
  #   $(".middle_results_container").on "click", ".trip_result_thumbnail_div a", (e) ->
  #     history.pushState {midcon: $('.middle_results_container').html(), herocon: $('.big_image_header').length }, document.title, location.url

  #   trips_namespace.updateContent = (data) ->
  #     $('.middle_results_container').html(data)
  #     $ ->
  #       $('.hasDatepicker').removeClass('hasDatepicker')
  #       $('button.results_traveler_type_multiselect').remove()
  #       trips_namespace.remoteLoadIndexFire()

  #   $(window).on "popstate", (e) ->
  #     # if (!trips_namespace.isInitialPageLoad)
  #     if (history.state)  
  #       trips_namespace.updateContent(history.state.midcon)
  #       unless (history.state.herocon > 0)
  #         $('.big_image_header').remove()
  #     # trips_namespace.isInitialPageLoad = false
  
  $ ->
    $(".middle_results_container").on "click", ".trip_result_thumbnail_div a", (e) ->
      alert ("hello_pushstate" + $(this).parents('.trip_result_thumbnail_div').find('.request_uri_hidden').html())
      history.pushState {first: $(this).parents('.trip_result_thumbnail_div').find('.request_uri_hidden').html()}, "", location.url
      console.log($(this).parent('.trip_result_thumbnail_div').find('.request_uri_hidden').html())

    $(window).on "popstate", (e) ->
      # alert ('hi_popstate_outside' + history.state.first)
      if (history.state && typeof history.state.first != 'undefined' )
        alert ('hello_popstate' +  history.state.first)
        console.log('hello_popsatte' +  history.state.first)  
        $.getScript(history.state.first)
        history.pushState {},"",location.url

  # History = window.History;

  # $ ->
  #   $(".middle_results_container").on "click", ".trip_result_thumbnail_div a", (e) ->
  #     alert ("hello_pushstate" + $(this).parents('.trip_result_thumbnail_div').find('.request_uri_hidden').html())
  #     History.pushState {first: $(this).parents('.trip_result_thumbnail_div').find('.request_uri_hidden').html()}, "", location.url
  #     console.log($(this).parent('.trip_result_thumbnail_div').find('.request_uri_hidden').html())

  #   History.Adapter.bind window, "statechange", ->
  #     State = History.getState()
  #     alert ('hi_popstate_outside' + State.data.first)
  #     if (State.data.first)
  #       alert ('hello_popstate' +  State.data.first)
  #       console.log('hello_popsatte' +  State.data.first)  
  #       $.getScript(State.data.first)

) window.trips_namespace = window.trips_namespace or {}, jQuery