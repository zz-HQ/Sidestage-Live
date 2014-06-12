vex.defaultOptions.className = "vex-theme-default"

$(document).on 'click', '[data-vex="ajax"]', (e) ->
  e.preventDefault()

  ajaxURL = $(@).attr('href')
  console.log ajaxURL
  $.ajax(
    method: "GET"
    url: ajaxURL
    headers:
      'X-Lightbox': true
  ).success (data, textStatus, jqXHR) ->
    vex.open
      content: data


