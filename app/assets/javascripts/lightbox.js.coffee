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
    vex.open
      content: data

$(document).on 'click', '[data-lightbox="html"]', (e) ->
  e.preventDefault()
  vex.close()
  vex.open
    content: $($(this).attr("data-target")).html()


