@showSuccess = ->
  $('#email-response-success').show()
  $('#email-response-error').hide()
  $('#animation-container').removeClass('error').addClass('success')

@showError = ->
  $('#email-response-success').hide()
  $('#email-response-error').show()
  $('#animation-container').removeClass('success').addClass('error')

  setTimeout ->
    $('#animation-container').removeClass('success error')
    $('#subscriber_email').trigger 'focus'
  , 1800

