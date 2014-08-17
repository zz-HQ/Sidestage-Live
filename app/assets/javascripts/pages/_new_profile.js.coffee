$(document).on 'change', '.new-profile-form .genre select', (e) ->
  return if $(this).val() == ""
  $('.new-profile-form .genre input[type="radio"]').removeAttr('checked').trigger('change')
  $('.new-profile-form .genre .nice-select').addClass('active')

$(document).on 'change', ".new-profile-form input[type='radio'][name='profile[genre_ids][]']", (e) ->
  if($(this).is(":checked"))
    $('.new-profile-form .genre select').val("").trigger("change")
    $('.new-profile-form .genre .nice-select').removeClass('active')
    

