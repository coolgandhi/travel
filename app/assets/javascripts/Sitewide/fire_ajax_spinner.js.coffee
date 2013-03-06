# hide it initially
$("#swipe-loading-indicator-header").hide().ajaxStart(->
  $(this).show()
).ajaxStop ->
  $(this).hide()
