#= require jquery_ujs
#= require turbolinks


window.App = {} if window.App == undefined
App = window.App

globalSearchCache = {}

App.init = ->

  #Begin Global Search
  
  $("form#global_search input[type=search]").autocomplete(
    minLength: 3
    source: $("form#global_search").attr("action")
    source: (request, response) ->
      term = request.term
      if term of globalSearchCache
        response globalSearchCache[term]
        return
      $.getJSON $("form#global_search").attr("action"), request, (data, status, xhr) ->
        globalSearchCache[term] = data
        response data
        return
    focus: (event, ui) ->
      return false
    select: (event, ui) ->
      window.location = ui.item.target
      return false
    ).data("ui-autocomplete")._renderItem = (ul, item) ->
      return $("<li></li>")
        .data("item.autocomplete", item)
        .append(item.label)
        .appendTo(ul)
  
  #End global search

$(document).on 'page:update', App.init