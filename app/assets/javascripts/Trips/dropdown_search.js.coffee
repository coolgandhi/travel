((trips_namespace, $, undefined_) ->
  #Toggles the dropdown on 'focus' of search bar
  #jQuery ->
    # $('.droptoggle_searchbar').click ->
    #   $('.droptoggle_menu').show()
      
    # $(".droptoggle_searchbar").on "select2-open", ->
    #   $(".droptoggle_menu").show()
        
    # $('.dropdown-close-button').click ->
    #       $('.droptoggle_menu').hide()

    # $('.dropdown-search-button').on('submit', $('.droptoggle_menu').hide())  
  
  # passing label and value of the dropdown search place field to hidden fields in dropdown form
  jQuery ->
    $('.droptoggle_searchbar').change ->
      if $('select.droptoggle_searchbar option:selected').text() != "Where would you like to go?"
        $('#search_submit_button').val("Chalo!")
        $('.dropdown_trip_location_id').val($('select.droptoggle_searchbar').val())
        $('.drophide-place-field').val($('select.droptoggle_searchbar option:selected').text())
        $('.dropdown-search-button').click()
  
  #Calling Multi-select
  $(document).ready ->
    $(".dropdown_traveler_type_multiselect").multiselect(
      noneSelectedText: 'Who are you going with?'
      selectedList: 4
      classes : "dropdown_traveler_type_multiselect"
      height: 'auto'
      header: false
    )
    $('.ui-multiselect.dropdown_traveler_type_multiselect').css('width', '280px');  

  #calling date from field datepicker
  jQuery ->
    $(".dropdown-from-datefield").datepicker()
    queryDate = $( ".dropdown-from-datefield" ).datepicker('setDate', new Date())

) window.trips_namespace = window.trips_namespace or {}, jQuery