((trips_namespace, $, undefined_) ->
  #Toggles the dropdown on 'focus' of search bar
  jQuery ->
    $('.droptoggle_searchbar').click ->
      $('.droptoggle_menu').show()

    $('.dropdown-close-button').click ->
  	  $('.droptoggle_menu').hide()

    $('.dropdown-search-button').on('submit', $('.droptoggle_menu').hide())  
  
  # passing label and value of the dropdown search place field to hidden fields in dropdown form
  jQuery ->
    $('.droptoggle_searchbar').change ->
      if $('select.droptoggle_searchbar option:selected').text() != "Where would you like to go?"
        $('#search_submit_button').val("Start Searching")
        $("#search_submit_button").removeClass("btn-flat-primary").addClass("btn-flat-success")
      else
        $('#search_submit_button').val("Search Trips")
        $("#search_submit_button").removeClass("btn-flat-success").addClass("btn-flat-primary")
      $('.dropdown_trip_location_id').val($('.droptoggle_searchbar').val())
      $('.drophide-place-field').val($('select.droptoggle_searchbar option:selected').text())
  
  #Calling Multi-select
  $(document).ready ->
    $(".dropdown_traveler_type_multiselect").multiselect(
      noneSelectedText: 'Who are you going with?'
      selectedList: 4
      classes : "dropdown_traveler_type_multiselect"
      height: 'auto'
    )
    $('.ui-multiselect.dropdown_traveler_type_multiselect').css('width', '280px');  

  #calling date from field datepicker
  jQuery ->
    $(".dropdown-from-datefield").datepicker()
    queryDate = $( ".dropdown-from-datefield" ).datepicker('setDate', new Date())

) window.trips_namespace = window.trips_namespace or {}, jQuery