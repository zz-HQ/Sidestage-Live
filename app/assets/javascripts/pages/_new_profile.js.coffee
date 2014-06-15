$(document).on 'change', '#new-profile .genre select', (e) ->
  return if $(this).val() == ""
  $('#new-profile .genre input[type="radio"]').removeAttr('checked').trigger('change')

$(document).on 'change', "#new-profile input[type='radio'][name='profile[genre_ids][]']", (e) ->
  if($(this).is(":checked"))
    $('#new-profile .genre select').val("").trigger("change")
    

