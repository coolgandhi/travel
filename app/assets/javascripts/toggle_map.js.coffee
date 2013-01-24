jQuery ->
  #using the .on jQuery function to delegate unbinded jquery function to AJAX loaded div
  # $("#wrapper").on "click", "#mapShowHide", (e) -> 
  #   $(".hiddenMapDiv").fadeToggle "slow"
  
  # $("#wrapper").on "click", "#flipper-check", (e) -> 
  #   $(this).siblings('.flipper').flip
  #     direction: "tb", content: $(".back")
  $("#wrapper").on "click", "#mapShowHide", (e) ->
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.back').show()
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.extraside').hide()
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').removeClass('flipped-again')
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').toggleClass('flipped')
    # text = (if $(this).text() is "Show Map" then "Close" else "Show Map")
    # $(this).text(text)

  $("#wrapper").on "click", "#infoShowHide", (e) ->
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.extraside').show()
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.back').hide()
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').removeClass('flipped')
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').toggleClass('flipped-again')

  $("#wrapper").on "click", "#hideAllButton", (e) ->
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').removeClass('flipped')
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').removeClass('flipped-again')

