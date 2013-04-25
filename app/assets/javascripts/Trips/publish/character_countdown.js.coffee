((trips_namespace, $, undefined_) ->


  trips_namespace.updateCountdown = -> 
    $(".word_count").on "input keyup keydown focus", ->
      $this = $(this)
      maxcharacters = $this.attr("maxcharacters")
      value = $this.val()
      counter = $this.next(".counter")
      if value.length < maxcharacters
        counter.removeClass "countdown_over"
      else
        counter.addClass "countdown_over"
      counter.text (maxcharacters - $this.val().length) + " characters remaining"

  jQuery ->  
    trips_namespace.updateCountdown()

    $(".publish_trip_create_activities").on "input keyup keydown focus", ".word_count", (e) ->
      trips_namespace.updateCountdown()    



) window.trips_namespace = window.trips_namespace or {}, jQuery