((trips_namespace, $, undefined_) ->
  #Toggles the dropdown on 'focus' of search bar
  jQuery ->
    $('.droptoggle-searchbar').focus ->
      $('.droptoggle-menu').show()

    $('.dropdown-close-button').click ->
  	  $('.droptoggle-menu').hide()

    $('.dropdown-search-button').on('submit', $('.droptoggle-menu').hide())  
  
  # passing label and value of the dropdown search place field to hidden fields in dropdown form
  jQuery ->
  	$('.droptoggle-searchbar').change ->
      $('.dropdown_trip_location_id').val($('.droptoggle-searchbar').val())
      $('.drophide-place-field').val($('select.droptoggle-searchbar option:selected').text())
  
  #Calling Multi-select
  $(document).ready ->
    $(".dropdown-traveler-type-multiselect").multiselect(
      noneSelectedText: 'your travel style?'
      selectedList: 4
      classes : "dropdown-traveler-type-multiselect"
      height: 'auto'
    )

  #calling date from field datepicker
  jQuery ->
    $(".dropdown-from-datefield").datepicker()
    queryDate = $( ".dropdown-from-datefield" ).datepicker('setDate', new Date())

) window.trips_namespace = window.trips_namespace or {}, jQuery