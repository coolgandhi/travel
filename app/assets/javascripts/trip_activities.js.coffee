jQuery ->
  $("#trip_map").gmap3
    marker:
      latLng:[29.132318972825445,81.32052349999992]
    options:
      draggable: false
    events:
      click: () ->
        alert "clicked"