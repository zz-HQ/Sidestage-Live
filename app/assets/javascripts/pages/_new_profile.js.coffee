$(document).on 'change', '#new-profile .genre select', (e) ->
  $('#new-profile .genre input[type="radio"]').removeAttr('checked').trigger('change')
