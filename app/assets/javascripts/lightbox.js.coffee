vex.defaultOptions.className = "vex-theme-default"

$(document).on 'click', '[data-lightbox="ajax"]', (e) ->
  e.preventDefault()

  ajaxURL = $(@).attr('href')
  $.ajax(
    method: "GET"
    url: ajaxURL
    headers:
      'X-Lightbox': true
  ).success (data, textStatus, jqXHR) ->
    vex.open
      content: data


