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

  trips_namespace.daySwatchSwitch = ->
    timetype = trips_namespace.slides[trips_namespace.gallery.pageIndex].timetype
    nextTime = (trips_namespace.gallery.pageIndex+1).toString()
    switch timetype
      when "1", "2"
        $(".swipeview-active").find(".time_day_swatch").removeClass("afternoon_sw").removeClass "evening_sw"
        $(".swipeview-active").find(".time_day_swatch").addClass "morning_sw"
        $('div[data-page-index=' + nextTime + ']').find(".time_day_swatch").addClass("morning_sw")
      when "3", "4"
        $(".swipeview-active").find(".time_day_swatch").removeClass("morning_sw").removeClass("evening_sw")
        $(".swipeview-active").find(".time_day_swatch").addClass "afternoon_sw"
        $('div[data-page-index=' + nextTime + ']').find(".time_day_swatch").addClass("afternoon_sw")
      when "5", "6", "7"
        $(".swipeview-active").find(".time_day_swatch").removeClass("afternoon_sw").removeClass("morning_sw")
        $(".swipeview-active").find(".time_day_swatch").addClass "evening_sw"
        $('div[data-page-index=' + nextTime + ']').find(".time_day_swatch").addClass("evening_sw")

) window.trips_namespace = window.trips_namespace or {}, jQuery