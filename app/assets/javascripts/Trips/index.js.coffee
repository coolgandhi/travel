((trips_namespace, $, undefined_) ->

  $ ->
    $("#from").datepicker()
  
    queryDate = $( "#from" ).datepicker('setDate', new Date())
  
    $("#to").datepicker()
  
    $("#to").datepicker('setDate', queryDate + 3)
  
    $("#trips").on "click", ".pagination a", (e) ->
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
          $.getScript url
          return
        if $(window).scrollTop() > 0
          $('#scrolltotop').fadeIn("slow")
        else
          $('#scrolltotop').fadeOut("slow")
      # $(window).scroll()
    return
  
) window.trips_namespace = window.trips_namespace or {}, jQuery