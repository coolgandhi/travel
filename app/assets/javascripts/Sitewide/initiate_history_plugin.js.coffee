((window, undefined_) ->
  
  # Prepare
  History = window.History # Note: We are using a capital H instead of a lower h
  
  # History.js is disabled for this browser.
  # This is because we can optionally choose to support HTML4 browsers or not.
  return false  unless History.enabled
  
  # Bind to StateChange Event
  History.Adapter.bind window, "statechange", -> # Note: We are using statechange instead of popstate
    State = History.getState() # Note: We are using History.getState() instead of event.state
    History.log State.data, State.title, State.url

) window