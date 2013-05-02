((author_namespace, $, undefined_) ->
  
  author_namespace.fireResizeAuthorPic = ->
    $(".ap_auth_img_tag").resizeToParent parent: ".author_profile_picture_div"
  
  jQuery ->
    author_namespace.fireResizeAuthorPic();

) window.author_namespace = window.author_namespace or {}, jQuery



