((trips_namespace, $, undefined_) ->


  trips_namespace.updateCountdown = -> 
    $(".word_count").each ->
      $this = $(this)
      $this.next(".counter").text (($this.attr("maxcharacters")- $this.val().length) + " characters remaining")
    $(".word_count").on "keydown", ->
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

    $(".publish_trip_create_activities").on "focus", ".word_count", (e) ->
      trips_namespace.updateCountdown()    



) window.trips_namespace = window.trips_namespace or {}, jQuery