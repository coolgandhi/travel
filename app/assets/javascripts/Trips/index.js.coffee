trips_namespace = trips_namespace || {}
((trips_namespace, undefined_) ->

  $ ->
    $("#from").datepicker()
    queryDate = $( "#from" ).datepicker('setDate', new Date())
    $("#to").datepicker()
    $("#to").datepicker('setDate', queryDate + 3)
    $("#trips").on "click", ".pagination a", (e) ->
      $.getScript(this.href);
      return false;
    return
  return

    
 
) trips_namespace