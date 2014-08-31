window.App = {} if window.App == undefined
App = window.App

App.initGooglePlaces = ->  
  $("#artist_place").each ->
    options =  types: ["(cities)"]
    autoCompMap = new google.maps.places.Autocomplete(document.getElementById("artist_place"), options)
    google.maps.event.addListener autoCompMap, "place_changed", ->
      $("#event_location").val(autoCompMap.getPlace().name)
      $("#event_location").closest("form").submit()
    
    google.maps.event.addDomListener document.getElementById("artist_place"), "keydown", (e) ->
      e.preventDefault()  if e.keyCode is 13
      return  