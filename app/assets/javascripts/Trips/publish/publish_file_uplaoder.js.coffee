((trips_namespace, $, undefined_) ->

  jQuery ->
    $(".publish_trip_create_activities").on "click", ".pt_upload_button", (e) ->
      $(".pt_upload_file").change ->
        $this = $(this)
        $this.closest('.pt_upload_button').siblings('.pt_upload_path').val $this.val().split('\\').pop()

) window.trips_namespace = window.trips_namespace or {}, jQuery