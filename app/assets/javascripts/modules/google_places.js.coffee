window.App = {} if window.App == undefined
App = window.App

App.initGooglePlaces = ->  
  $("[data-google='event_place']").each ->
    inputField = $(@)
    options =  types: ["(cities)"]
  
    autoCompMap = new google.maps.places.Autocomplete(document.getElementById($(@).attr("id")), options)
  
    google.maps.event.addListener autoCompMap, "place_changed", ->
      lat = autoCompMap.getPlace().geometry.location.lat()
      lng = autoCompMap.getPlace().geometry.location.lng()
      
      inputField.parent().find("input[name=lat]").val(lat)
      inputField.parent().find("input[name=lng]").val(lng)
      inputField.closest("form").submit()
    
    google.maps.event.addDomListener document.getElementById($(@).attr("id")), "keydown", (e) ->
      e.preventDefault()  if e.keyCode is 13
      return
  
  $("form input[data-name=location]").each ->
    inputField = $(@)
    options =  types: ["(cities)"]
    
    artistMap = new google.maps.places.Autocomplete(document.getElementById($(@).attr("id")), options)
    
    google.maps.event.addListener artistMap, "place_changed", ->      
      latitude = artistMap.getPlace().geometry.location.lat()
      longitude = artistMap.getPlace().geometry.location.lng()
      country_short = artistMap.getPlace().address_components[artistMap.getPlace().address_components.length-1].short_name
      country_long = artistMap.getPlace().address_components[artistMap.getPlace().address_components.length-1].long_name
      form = inputField.closest("form")      
      form.find("input[data-name='latitude']").val(latitude)
      form.find("input[data-name='longitude']").val(longitude)
      form.find("input[data-name='country_short']").val(country_short)
      form.find("input[data-name='country_long']").val(country_long)
      inputField.closest("form[data-geo='submit']").trigger 'submit'
    google.maps.event.addDomListener document.getElementById($(@).attr("id")), "keydown", (e) ->
      e.preventDefault()  if e.keyCode is 13
      return