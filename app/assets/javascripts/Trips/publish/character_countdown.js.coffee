((trips_namespace, $, undefined_) ->

  updateCountdown = (limit=200) ->
    maxcharacter = limit
    characters =  $(".message" + maxcharacter).val().length
    remaining = maxcharacter - $(".message" + maxcharacter).val().length
    countdown = $(".countdown" + maxcharacter)

    if characters > maxcharacter
      countdown.addClass "countdown_over"
    else
      countdown.removeClass "countdown_over"

    $(".countdown" + maxcharacter).text remaining + " characters remaining."

  jQuery -> 
    updateCountdown(40)
    $(".message40").change -> 
      updateCountdown(40)
    $(".message40").keyup ->
      updateCountdown(40)

    updateCountdown(200)
    $(".message200").change -> 
      updateCountdown(200)
    $(".message200").keyup ->
      updateCountdown(200)

) window.trips_namespace = window.trips_namespace or {}, jQuery