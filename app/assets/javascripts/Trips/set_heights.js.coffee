wrap_heights = ->
  $('#wrappiest').css "height", "" + Math.round(.7 * $(window).height())
  $('.wrapper-film').css "height", "" + Math.round(.7 * $(window).height())

wrap_widths = ->
  $('#comments').css "width", "" + Math.round(.6 * $(window).width())

$(document).ready ->
  wrap_heights()
  # wrap_widths()
  $(window).on "resize", wrap_heights
  # $(window).on "resize", wrap_widths