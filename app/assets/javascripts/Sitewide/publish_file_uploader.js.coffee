((trips_namespace, $, undefined_) ->

  trips_namespace.firePublishPhotoUploaderBox = ->
    $(".pt_upload_file").change ->
      $this = $(this)
      $this.closest('.pt_upload_button').siblings('.pt_upload_path').val $this.val().split('\\').pop()
      # console.log('this event is firing')
      $this.closest('.pt_upload_field').parents('.upload_pic_parent_box').find('.uploaded_image_preview').html('<p class = "update_image_p"><i class="icon-bell icon-3x"></i></br>Please Click Update to Save Your Change</p>')
      $this.closest('.pt_upload_field').parents('.upload_pic_parent_box').find('.uploaded_image_msg').html("You've updated an image to upload")
    #resize the img preview of uploaded image to parent
    trips_namespace.fireResizePublishImages = ->
      $(".pt_activity_upload_img").resizeToParent parent: "#yes_upload_div"


  jQuery ->
    trips_namespace.firePublishPhotoUploaderBox();
    trips_namespace.fireResizePublishImages();

    $(".publish_trip_create_activities").on "click", ".pt_upload_button", (e) ->
      trips_namespace.firePublishPhotoUploaderBox();

    $("a[data-toggle=\"tab\"]").on "shown", (e) ->
      trips_namespace.fireResizePublishImages();

) window.trips_namespace = window.trips_namespace or {}, jQuery