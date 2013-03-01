#Toggles the dropdown on 'focus' of search bar
jQuery ->
  $('.droptoggle-searchbar').focus ->
    # $('.navbar-search').dropdown()
    $('.droptoggle-menu').show()
    #Prevents the dropdown function to toggle off the dropdown again when clicking inside the dropdown
    # $(".droptoggle-form, .droptoggle-form label, .droptoggle-form input, .ui-multiselect-checkboxes, .ui-multiselect-menu").click (e) ->
    # $(".droptoggle-form, .droptoggle-form label, .droptoggle-form input").click (e) ->	
    #   e.stopPropagation()
  #dropdown cancel button
  $('.dropdown-close-button, .dropdown-search-button').click ->
  	$('.droptoggle-menu').hide()


#Calling Autocomplete on the condensed place-text-field
# jQuery ->        
#   $('.droptoggle-searchbar').autocomplete
#     minLength: 3
#     source: (request, response) ->
#       $.ajax 
#         url: window.location.protocol + "//" + window.location.host + "/locations/pick.json"
#         dataType: "json"
#         data: 
#           total: 10
#           near: request.term
#         success: (data) ->
#           response $.map(data, (item) ->
#             label: item.city + ", " + item.state + ", " + item.country 
#             value: item.location_id + "," + item.latitude + "," + item.longitude
#             )
#     open: ->
#       $(this).removeClass(".droptoggle-searchbar").addClass "ui-corner-top"
#     close: ->
#       $(this).removeClass("ui-corner-top").addClass "ui-corner-all"
#     focus: (event, ui) ->
#       event.preventDefault()
#       $(this).val ui.item.label      
#     select: (event, ui) ->
#       event.preventDefault()
#       splitarrayvalue = ui.item.value.split(",")
#       splitarraylabel = ui.item.label.split(",")
#       $('.trip_location_id').val( splitarrayvalue[0] )
#       $(this).val ui.item.label
#       $('.drophide-place-field').val(ui.item.label) #Pass on the location name to hidden field to submit
#       $(this).siblings('.droptoggle-searchbar').val splitarrayvalue[0]
  
  # passing label and value of the dropdown search place field to hidden fields in dropdown form
  jQuery ->
  	$('.droptoggle-searchbar').change ->
      $('.trip_location_id').val($('.droptoggle-searchbar').val())
      $('.drophide-place-field').val($('select.droptoggle-searchbar option:selected').text())
  
  #Calling Multi-select
  $(document).ready ->
    $(".dropdown-traveler-type-multiselect").multiselect(
      noneSelectedText: 'Your traveler type'
      selectedList: 4
      classes : "dropdown-traveler-type-multiselect"
      height: 'auto'
    )

  #calling date from field datepicker
  jQuery ->
    $(".dropdown-from-datefield").datepicker()
    queryDate = $( ".dropdown-from-datefield" ).datepicker('setDate', new Date())
