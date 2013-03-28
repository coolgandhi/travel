((trips_namespace, $, undefined_) ->

  # passing values to hidden fields for results search bar
  trips_namespace.fireResultsPlaceDropdownField = -> 
    $('.results_place_dropdown_field').change ->
      $('.results_trip_location_id').val($('.results_place_dropdown_field').val())
      $('.results_hidden_place_field').val($('select.results_place_dropdown_field option:selected').text())
  
  #Calling Multi-select
  trips_namespace.fireResultsTravelerTypeMultiSelect = ->
    $(".results_traveler_type_multiselect").multiselect(
      noneSelectedText: 'For what travel styler?'
      selectedList: 4
      classes : "results_traveler_type_multiselect"
      height: 'auto'
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