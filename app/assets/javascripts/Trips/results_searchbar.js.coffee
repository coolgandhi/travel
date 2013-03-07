((trips_namespace, $, undefined_) ->

  # passing values to hidden fields for results search bar
  trips_namespace.fireResultsPlaceDropdownField = -> 
    $('.results-place_dropdown_field').change ->
      $('.results-trip_location_id').val($('.results-place_dropdown_field').val())
      $('.results-hidden-place-field').val($('select.results-place_dropdown_field option:selected').text())
  
  #Calling Multi-select
  trips_namespace.fireResultsTravelerTypeMultiSelect = ->
    $(".results_traveler_type_multiselect").multiselect(
      noneSelectedText: 'Your traveler type?'
      selectedList: 4
      classes : "results_traveler_type_multiselect"
      height: 'auto'
    )
    $('.ui-multiselect.results_traveler_type_multiselect').css('width', '200px');  

  #calling date from field datepicker
  trips_namespace.fireResultsFromField = ->
    $(".results-from-datefield").datepicker();
    queryDate = $( ".results-from-datefield" ).datepicker('setDate', new Date());

  #carry params forward from previous search
  trips_namespace.fireResultsPopulateFields = (location_id, place_text, from_date, days_field) ->
    $('.results-place_dropdown_field').val(location_id)
    $('.results-trip_location_id').val(location_id)
    $('.results-hidden-place-field').val(place_text)
    $('.results-from-datefield').val(from_date)
    $('.results-day-field').val(days_field)

  trips_namespace.fireResultSearchBarJs = ->
    trips_namespace.fireResultsPlaceDropdownField()
    trips_namespace.fireResultsTravelerTypeMultiSelect()
    trips_namespace.fireResultsFromField()

  jQuery ->
    trips_namespace.fireResultSearchBarJs()

) window.trips_namespace = window.trips_namespace or {}, jQuery