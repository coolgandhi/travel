# # Reference to your iFrame HTML element
# iFrameElement = $('.fb_iframe_widget').find('iframe')
# # alert($('.bottom-actionlinks').dataType)

# # Avoid clipping by applying simple css transfrom3D to the iframe content itself
# $(iFrameElement.contentWindow.document.body).css "-webkit-transform", "translate3d(0,0,0)"

# jQuery ->
#   # Reference to your iFrame HTML element
#   iFrameElement = $('iframe').contents().find('body')
#   alert($('iframe').contents().find('body').attr('name'))
#   # # Avoid clipping by applying simple css transfrom3D to the iframe content itself
#   $(iFrameElement).css('background-color', 'red')
#   # Start your iFrame transition (from a visible position)
#   $(iFrameElement).css('color', 'green')