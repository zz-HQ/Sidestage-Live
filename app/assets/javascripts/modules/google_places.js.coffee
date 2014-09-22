window.App = {} if window.App == undefined
App = window.App

App.initGooglePlaces = ->  
  $("[data-google='event_place']").each ->
    inputField = $(@)
    options =  types: ["(regions)"]
  
    autoCompMap = new google.maps.places.Autocomplete(document.getElementById($(@).attr("id")), options)

    google.maps.event.addListener autoCompMap, "place_changed", ->
      console.log(autoCompMap.getPlace());
      lat = autoCompMap.getPlace().geometry.location.lat()
      lng = autoCompMap.getPlace().geometry.location.lng()
      
      inputField.parent().find("input[name=lat]").val(lat)
      inputField.parent().find("input[name=lng]").val(lng)
      inputField.closest("form").submit()
    
    google.maps.event.addDomListener document.getElementById($(@).attr("id")), "keydown", (e) ->
      e.preventDefault()  if e.keyCode is 13
      return