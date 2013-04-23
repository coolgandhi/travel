jQuery ->
  $('.hide_floating_convo').click (event) ->
    event.preventDefault();
    $('.floating_front_page_convo').fadeOut()