((trips_namespace, $, undefined_) ->

  # passing values to hidden fields for results search bar
  trips_namespace.fireResultsPlaceDropdownField = -> 
    $('.results_place_dropdown_field, .results_traveler_type_multiselect, .results_day_field').change ->
      if $('select.results_place_dropdown_field option:selected').text() != "Where would you like to go?"
        $("#search_submit_button").val("Chalo!")
        $("#search_submit_button").removeClass("btn-flat-primary").addClass("btn-flat-warning")
      else
        $("#search_submit_button").val("Search Trips")
        $("#search_submit_button").removeClass("btn-flat-warning").addClass("btn-flat-primary")
      $('.results_trip_location_id').val($('.results_place_dropdown_field').val())
      $('.results_hidden_place_field').val($('select.results_place_dropdown_field option:selected').text())
  
  #Calling Multi-select
  trips_namespace.fireResultsTravelerTypeMultiSelect = ->
    $(".results_traveler_type_multiselect").multiselect(
      noneSelectedText: 'Who are you going with?'
      selectedList: 4
      classes : "results_traveler_type_multiselect"
      height: 'auto'
      header: false
    )
    $('.ui-multiselect.results_traveler_type_multiselect').css('width', '200px');  

  #calling date from field datepicker
  trips_namespace.fireResultsFromField = ->
    $(".results_from_datefield").datepicker();
    # queryDate = $( ".results_from_datefield" ).datepicker('setDate', new Date());

  #carry params forward from previous search
  trips_namespace.fireResultsPopulateFields = (location_id, place_text, from_date, days_field) ->
    $('.results_place_dropdown_field').val(location_id)
    $('.results_trip_location_id').val(location_id)
    $('.results_hidden_place_field').val(place_text)
    $('.results_from_datefield').val(from_date)
    $('.results-day-field').val(days_field)

  trips_namespace.fireResultSearchBarJs = ->
    trips_namespace.fireResultsPlaceDropdownField()
    trips_namespace.fireResultsTravelerTypeMultiSelect()
    trips_namespace.fireResultsFromField()

  jQuery ->
    trips_namespace.fireResultSearchBarJs()

) window.trips_namespace = window.trips_namespace or {}, jQuery