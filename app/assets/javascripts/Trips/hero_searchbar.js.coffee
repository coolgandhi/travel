((trips_namespace, $, undefined_) ->

  # passing values to hidden fields for hero search bar
  trips_namespace.firePlaceDropdownField = -> 
    $('.place_dropdown_field').change ->
      if $('select.place_dropdown_field option:selected').text() != "Where would you like to go?"
        $("#search_submit_button").val("Start Searching")
        $("#search_submit_button").removeClass("btn-flat-primary").addClass("btn-flat-success")
      else
        $("#search_submit_button").val("Search Trips")
        $("#search_submit_button").removeClass("btn-flat-success").addClass("btn-flat-primary")
      $('.hero_trip_location_id').val($('.place_dropdown_field').val())
      $('.hero-hidden-place-field').val($('select.place_dropdown_field option:selected').text())
  
  #Calling Multi-select
  trips_namespace.fireTravelerTypeMultiSelect = ->
    $(".traveler_type_multiselect").multiselect(
      noneSelectedText: 'Who are you going with?'
      selectedList: 4
      classes : "traveler_type_multiselect"
      height: 'auto'
    )  

  #calling date from field datepicker
  trips_namespace.fireFromField = ->
    $(".from-datefield").datepicker()
    queryDate = $(".from-datefield" ).datepicker('setDate', new Date())
    # $("#to").datepicker()
    # $("#to").datepicker('setDate', queryDate + 3)

  jQuery -> 
    trips_namespace.firePlaceDropdownField()
    trips_namespace.fireTravelerTypeMultiSelect()
    trips_namespace.fireFromField()

) window.trips_namespace = window.trips_namespace or {}, jQuery