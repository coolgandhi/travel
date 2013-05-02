((trips_namespace, $, undefined_) ->

  trips_namespace.firePublishPhotoUploaderBox = ->
    $(".pt_upload_file").change ->
      $this = $(this)
      $this.closest('.pt_upload_button').siblings('.pt_upload_path').val $this.val().split('\\').pop()
    
    #resize the img preview of uploaded image to parent
    trips_namespace.fireResizePublishImages = ->
      $(".pt_activity_upload_img").resizeToParent parent: "#yes_upload_div"


  jQuery ->
    trips_namespace.firePublishPhotoUploaderBox();
    trips_namespace.fireResizePublishImages();

    $(".publish_trip_create_activities").on "click", ".pt_upload_button", (e) ->
      trips_namespace.firePublishPhotoUploaderBox();

    $('.publish_trip_collapse_content').on "show", (e) ->
      trips_namespace.fireResizePublishImages();

) window.trips_namespace = window.trips_namespace or {}, jQuery