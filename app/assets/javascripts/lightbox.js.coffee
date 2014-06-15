vex.defaultOptions.className = "vex-theme-default"

$(document).on 'click', '[data-lightbox="ajax"]', (e) ->
  e.preventDefault()

  vex.close()
  
  ajaxURL = $(@).attr('href')
  $.ajax(
    method: "GET"
    url: ajaxURL
    headers:
      'X-Lightbox': true
  ).success (data, textStatus, jqXHR) ->
    console.log(textStatus)
    vex.open
      content: data
  .error (data, textStatus, jqXHR) ->    
    alert(textStatus)

$(document).on 'click', '[data-lightbox="html"]', (e) ->
  e.preventDefault()
  vex.close()
  vex.open
    content: $($(this).attr("data-target")).html()

# $(document).on 'click', '[data-lightbox="html"]', (e) ->
#   e.preventDefault()
#   vex.close()
#   vex.open
#     content: $($(this).attr("data-target")).html()



