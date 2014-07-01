$(document).on 'change', '#profile-form .genre select', (e) ->
  return if $(this).val() == ""
  $('#profile-form .genre input[type="radio"]').removeAttr('checked').trigger('change')
  $('#profile-form .genre .nice-select').addClass('active')

$(document).on 'change', "#profile-form input[type='radio'][name='profile[genre_ids][]']", (e) ->
  if($(this).is(":checked"))
    $('#profile-form .genre select').val("").trigger("change")
    $('#profile-form .genre .nice-select').removeClass('active')
    

