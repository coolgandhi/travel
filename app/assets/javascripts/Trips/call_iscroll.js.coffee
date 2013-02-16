jQuery(document).ready ($) ->
  if Modernizr.touch	
    commentsScroller = new iScroll("bottom-actionlinks")
    filmScroller = new iScroll("filmstrip-scroll")
    overviewScroller = new iScroll("scroll-modal-body")