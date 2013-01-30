jQuery ->
  #using the .on jQuery function to delegate unbinded jquery function to AJAX loaded div
  # $("#swipewrapper").on "click", "#mapShowHide", (e) -> 
  #   $(".hiddenMapDiv").fadeToggle "slow"
  
  # $("#swipewrapper").on "click", "#flipper-check", (e) -> 
  #   $(this).siblings('.flipper').flip
  #     direction: "tb", content: $(".back")
  $("#swipewrapper").on "click", "#mapShowHide", (e) ->
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.back').show()
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.extraside').hide()
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').removeClass('flipped-again')
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').toggleClass('flipped')
    $(this).toggleClass('active').promise().done ->
      if $(this).class = "active" then $(this).siblings('#infoShowHide').removeClass('active') && $(this).siblings('#hideAllButton').removeClass('active')
      if $(this).hasClass('active') == false then $(this).siblings('#hideAllButton').addClass('active')

  $("#swipewrapper").on "click", "#infoShowHide", (e) ->
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.extraside').show()
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').children('.back').hide()
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').removeClass('flipped')
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').toggleClass('flipped-again')
    $(this).toggleClass('active').promise().done -> 
      if $(this).class = "active" then $(this).siblings('#mapShowHide').removeClass('active') && $(this).siblings('#hideAllButton').removeClass('active')
      if $(this).hasClass('active') == false then $(this).siblings('#hideAllButton').addClass('active')


  $("#swipewrapper").on "click", "#hideAllButton", (e) ->
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').removeClass('flipped')
    $(this).parents('#moreShowHideGroup').siblings('.flip-container').children('.flipper').removeClass('flipped-again')
    $(this).addClass('active')
    $(this).siblings('.btn').removeClass('active')


