((trips_namespace, $, undefined_) ->

  $ ->
    $("#from, .from-datefield").datepicker()
  
    queryDate = $( "#from, .from-datefield" ).datepicker('setDate', new Date())
  
    $("#to").datepicker()
  
    $("#to").datepicker('setDate', queryDate + 3)
  
    $("#trips-results-container").on "click", ".pagination a", (e) ->
      $.getScript this.href, ->
        try
          FB.XFBML.parse()
        return
      return false

    $('#scrolltotop').on "click", null, (e) ->
      $("html, body").animate({
         scrollTop: 0
      }, "slow")
      $('#scrolltotop').fadeOut("slow")
      $('#scrolltotop').hide()
  
    if $('.pagination').length
      $(window).scroll ->
        $('.pagination').hide()
        url = $('.pagination .next_page').attr('href')
        if url && $(window).scrollTop() > $(document).height() - $(window).height() - 50
          $('.pagination').text('Fetching pins')
          $('.continuous-loading-indicator-wrapper').show()
          $.getScript(url).done ->
            $('.continuous-loading-indicator-wrapper').hide()
          return
        if $(window).scrollTop() > 0
          $('#scrolltotop').fadeIn("slow")
        else
          $('#scrolltotop').fadeOut("slow")
      # $(window).scroll()
    return
  
) window.trips_namespace = window.trips_namespace or {}, jQuery