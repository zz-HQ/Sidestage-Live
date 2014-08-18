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
    if($(@).val() != "More cities")
      $(@).closest('form').trigger 'submit'
    else
      window.location.replace("/en/city_launches/new")

$(document).on 'change', '.redirect-on-change-to-other', (e) -> 
  if($(@).val() == "More cities")
      window.location.replace("/en/city_launches/new")

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

$.ajaxSetup
  headers:
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')
    'Accept': "text/javascript, application/javascript, text/html"


flashMessage = (name, msg) ->
  $('#flash-messages').find(".flash").addClass name
  $('#flash-messages').find(".flash-message").html msg
  $('#flash-messages').delay(100).animate
    height: '60px'
  ,
    duration: 150
    # ab hier auskommentieren, damit es offen bleibt
    complete: ->
      $(this).delay(3000)
      .animate
        height: 0
      ,
        duration: 200


$(document).on 'page:update', App.init
$ -> App.init()


# Validation form
validateDetails = ->
  expiry = $('.cc-exp').payment('cardExpiryVal')
  validateExpiry = $.payment.validateCardExpiry(expiry["month"], expiry["year"])
  validateCVC = $.payment.validateCardCVC($('.cc-cvc').val())

  # if statement on whether the card’s expiry is valid or not
  if validateExpiry
  
    # if the expiry is valid add the identified class
    $(".cc-exp").addClass "identified"
  else
    
    # remove again if the expiry becomes invalid
    $(".cc-exp").removeClass "identified"

  # if statement on whether the card’s cvc is valid or not
  if validateCVC
    
    # if the cvc is valid add the identified class
    $(".cc-cvc").addClass "identified"
  else
    
    # remove again if the cvc becomes invalid
    $(".cc-cvc").removeClass "identified"

$(document).on "change paste keyup", ".paymentInput", ->
  validateDetails()


#SUBMIT VIA ENTER
$(document).on 'keydown', '.media-type-form input', (e) ->
  if e.keyCode == 13
    $(@).closest('form').trigger 'submit'

$(document).on 'click', '.media-type-form .open-input-field', ->
  $(@).parent().hide()
  $(@).closest(".tab").find(".media-type-input-field").show()



# CLICK ON LOGO, RETURN TO ARTISTS
$(document).on 'click', "#logo a", (e) ->
  e.preventDefault()
  window.location.replace("/")