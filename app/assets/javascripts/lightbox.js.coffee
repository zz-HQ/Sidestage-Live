vex.defaultOptions.className = "vex-theme-default"

$(document).on 'click', '[data-lightbox="ajax"]', (e) ->
  e.preventDefault()

  vex.closeAll()
  
  ajaxURL = $(@).attr('href')
  $.ajax(
    method: "GET"
    url: ajaxURL
    headers:
      'X-Lightbox': true
  ).success (data, textStatus, jqXHR) ->
    vex.open
      content: data
  .error (data, textStatus, jqXHR) ->
    alert(textStatus)

$(document).on 'click', '[data-lightbox="html"]', (e) ->
  e.preventDefault()
  vex.closeAll()
  vex.open
    content: $($(this).attr("data-target")).html()

jQuery(document).ready ->
  $("[data-lightbox=\"auto\"]").each (i, e) ->
    vex.open content: $(e).html()
  return