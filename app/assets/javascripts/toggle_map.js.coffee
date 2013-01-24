jQuery ->
  #using the .on jQuery function to delegate unbinded jquery function to AJAX loaded div
  $("#wrapper").on "click", "#mapShowHide", (e) -> 
    $(".hiddenMapDiv").fadeToggle "slow"