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
#= require turbolinks
#= require boilerplate
#= require jquery.datetimepicker
#= require_tree ./modules
#= require_tree .

window.App = {} if window.App == undefined
App = window.App

App.init = ->
  $('.nice-select').niceSelect()
  $('nav.tabs').tabs()
  $('.date-picker').datetimepicker
    timepicker:false
    format:'Y-m-d'

$(document).on 'page:update', App.init
$ -> App.init()

$(document).on 'change', '.submit-on-change', (e) -> $(@).closest('form').trigger 'submit'
