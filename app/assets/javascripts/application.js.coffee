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
  $('.nice-select').niceSelect()
  $('nav.tabs').tabs()
  $('.styled-radios').styledRadios()
  $('.star-rating-editable').starRating()
  $('#flash-messages').flash()
  $('.picture-viewer').pictureViewer()
  $('.tabs').toggleMediaFields()
  $('.date-picker').datetimepicker
    timepicker: false
    format: 'j/n/Y'
    scrollInput: false
    minDate:'-1970/01/01'
    onChangeDateTime: (dp,$input) -> $($input).datetimepicker 'hide'
  $("input.cc-num").payment "formatCardNumber"
  $("input.cc-cvc").payment "formatCardCVC"
  $("input.cc-exp").payment  "formatCardExpiry"
  App.setBalancedCardListener()
  App.initGooglePlaces()

$(document).on 'click', '[data-trigger=reset_artist_filter]', (e) ->
  $("form#artist_filter").reset()
  $("form#artist_filter select").trigger("change")
  $("form#artist_filter").trigger("change")
  return false

$(document).on 'change', '.submit-on-change', (e) -> 
  if($(@).val() != "")
      $(@).closest('form').trigger 'submit'

$(document).on 'change', '[data-auto-save=true]', (e) -> 
  $(@).trigger 'submit'

$(document).on 'change', 'select[data-linked=true]', (e) -> 
  window.location.replace($(@).val())

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

$(document).on 'click', '.close', (e) ->
    e.preventDefault()
    $(@).closest('#cookies').fadeOut(200)

$(document).on 'click', '#trigger-email-signup-form', (e) ->
  $(@).hide()
  $(".signup-with-email").show()#slideDown()

$(document).on 'change', "form select[name*=mobile_nr_country_code]", (e) ->
  $("form #country_calling_code").text("+" + $(@).val())

$.ajaxSetup
  headers:
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    'Accept': "text/javascript, application/javascript, text/html"

$(document).on 'page:update', App.init
#$ -> App.init()

#SUBMIT VIA ENTER
$(document).on 'keydown', '.media-type-form input', (e) ->
  if e.keyCode == 13
    $(@).closest('form').trigger 'submit'

# MATCH ME CHECKBOX -----------
$(document).on 'click', '.match-me-form .act', ->
  if $(@).find(':checkbox').is(':checked')
    $(@).find(':checkbox').prop('checked', false)
    $(@).removeClass('active')
  else if $('.act.active').length + 1 <= 3
    $(@).find(':checkbox').prop('checked', true)
    $(@).addClass('active')

# Characters counter
$(document).on 'keyup', '#profile_about', ->
  chars = $('#profile_about').val().length
  $('.characters-counter .count').html 747 - chars

# Profile about read more link
$(document).on 'click', '.toggle-about-text', ->
  $(@).closest('div').hide()
  if $(@).hasClass("show-fulltext")
    $('.fulltext').show()
  else
    $('.truncate').show()

# Filter loader
# $(document).on 'change', 'form.filter select', ->
#   setTimeout ->
#     $('.results-body').addClass('loading')
#   , 20

# FB LIKE BUTTON to work with turbolinks
fb_root = null
fb_events_bound = false

$ ->
  loadFacebookSDK()
  bindFacebookEvents() unless fb_events_bound

bindFacebookEvents = ->
  $(document)
    .on('page:fetch', saveFacebookRoot)
    .on('page:change', restoreFacebookRoot)
    .on('page:load', ->
      FB.XFBML.parse()
    )
  fb_events_bound = true

saveFacebookRoot = ->
  fb_root = $('#fb-root').detach()

restoreFacebookRoot = ->
  if $('#fb-root').length > 0
    $('#fb-root').replaceWith fb_root
  else
    $('body').append fb_root

loadFacebookSDK = ->
  window.fbAsyncInit = initializeFacebookSDK
  $.getScript("//connect.facebook.net/en_US/all.js#xfbml=1")

initializeFacebookSDK = ->
  FB.init
    appId     : '1438427953107579'
    channelUrl: '//www.sidestage.com/channel.html'
    status    : true
    cookie    : true
    xfbml     : true

# TWITTER SHARE BUTTON to with turbolinks
twttr_events_bound = false

$ ->
  loadTwitterSDK()
  bindTwitterEventHandlers() unless twttr_events_bound

bindTwitterEventHandlers = ->
  $(document).on 'page:load', renderTweetButtons
  twttr_events_bound = true

renderTweetButtons = ->
  $('.twitter-share-button').each ->
    button = $(this)
    button.attr('data-url', document.location.href) unless button.data('url')?
    button.attr('data-text', document.title) unless button.data('text')?
  twttr.widgets.load()

loadTwitterSDK = ->
  $.getScript("//platform.twitter.com/widgets.js")
  
jQuery.fn.reset = ->
  $(this).each ->
    @reset()
    return
  return