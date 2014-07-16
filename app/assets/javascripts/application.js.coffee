# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
# require turbolinks
#= require boilerplate
#= require jquery.datetimepicker
#= require vex/vex.combined.min
#= require jquery-fileupload/basic
#= require jquery-fileupload/vendor/tmpl
#= require_tree ./modules
#= require_tree ./pages
#= require_tree .

window.App = {} if window.App == undefined
App = window.App

App.init = ->
  $('.about').expander({
    slicePoint:       300
    expandPrefix:     '... ' # default is '... '
    expandText:       'read more' # default is 'read more'
    userCollapseText: '[^]'
    expandEffect: 'slideDown'
    collapseEffect: 'slideUp'
  })
  $('.nice-select').niceSelect()
  $('nav.tabs').tabs()
  $('.styled-radios').styledRadios()
  $('.star-rating-editable').starRating()
  $('#flash-messages').flash()
  $('.picture-viewer').pictureViewer()
  $('.date-picker').datetimepicker
    timepicker: false
    format: 'j/n/Y'
    scrollInput: false
    minDate:'-1970/01/01'
    onChangeDateTime: (dp,$input) -> $($input).datetimepicker 'hide'
  App.setStripeListener()

$(document).on 'change', '.submit-on-change', (e) -> 
  if($(@).val() != "")
    if($(@).val() != "Other")
      $(@).closest('form').trigger 'submit'
    else
      window.location.replace("/en/city_launches/new")

$(document).on 'change', '.redirect-on-change-to-other', (e) -> 
  if($(@).val() == "Other")
      window.location.replace("/en/city_launches/new")

$(document).on 'click', '[data-toggle]', (e) -> 
  $($(this).attr("data-toggle")).toggle()
  return false

$(document).on 'submit', '#homepage-search', (e) ->
  if($(this).find("select#location").val() == "")
    e.preventDefault()
    return false

$(document).on 'click', '#close-vex', (e) ->
    e.preventDefault()
    $('.vex-close').trigger 'click'

$(document).on 'click', '#fileupload-button', (e) ->
  e.preventDefault()
  $('#file').trigger 'click'

$.ajaxSetup
  headers:
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    'Accept': "text/javascript, application/javascript, text/html"

$(document).on 'page:update', App.init
$ -> App.init()
