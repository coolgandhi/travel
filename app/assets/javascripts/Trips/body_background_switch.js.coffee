((trips_namespace, $, undefined_) ->
  trips_namespace.bodyBackgroundImageSwitch = ->
    timetype = trips_namespace.slides[trips_namespace.gallery.pageIndex].timetype
    switch timetype
      when "1", "2"
        $("div.evening_bg").fadeOut 2000
        $("div.afternoon_bg").fadeOut 2000
        $("body").removeClass("afternoon_bg").removeClass "evening_bg"
        $("body").addClass "morning_bg"
        
        # $('body').animate({ backgroundColor: '#DEEFFA' }, 2000)
        $("div.morning_bg").fadeIn 2000
      when "3", "4"
        $("div.morning_bg").fadeOut 2000
        $("div.evening_bg").fadeOut 2000
        $("body").removeClass("morning_bg").removeClass "evening_bg"
        $("body").addClass "afternoon_bg"
        
        # $('body').animate({ backgroundColor: '#8dc0d9' }, 2000)
        $("div.afternoon_bg").fadeIn 2000
      when "5", "6", "7"
        $("div.morning_bg").fadeOut 2000
        $("div.afternoon_bg").fadeOut 2000
        $("body").removeClass("afternoon_bg").removeClass "morning_bg"
        $("body").addClass "evening_bg"
        
        # $('body').animate({ backgroundColor: '#365165' }, 2000)
        $("div.evening_bg").fadeIn 2000
) window.trips_namespace = window.trips_namespace or {}, jQuery