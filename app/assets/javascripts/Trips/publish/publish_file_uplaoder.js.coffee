((trips_namespace, $, undefined_) ->


  trips_namespace.firePublishPhotoUploaderBox = ->
    $(".pt_upload_file").change ->
      $this = $(this)
      $this.closest('.pt_upload_button').siblings('.pt_upload_path').val $this.val().split('\\').pop()

  jQuery ->
    trips_namespace.firePublishPhotoUploaderBox();
    $(".publish_trip_create_activities").on "click", ".pt_upload_button", (e) ->
      trips_namespace.firePublishPhotoUploaderBox()

) window.trips_namespace = window.trips_namespace or {}, jQuery