wrap_heights = ->
  $('#wrappiest').css "height", "" + Math.round(.7 * $(window).height())
  $('.wrapper-film').css "height", "" + Math.round(.7 * $(window).height())

$(document).ready ->
  wrap_heights()
  $(window).on "resize", wrap_heights