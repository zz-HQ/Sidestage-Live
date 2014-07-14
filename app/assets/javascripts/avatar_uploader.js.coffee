$(document).on 'ready page:load page:restore', ->
  filesCount = 0

  $('#user_account').fileupload
    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png|GIF|JPE?G|PNG)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        filesCount += 1
        data.submit()
      else
        alert("#{file.name} is not a gif, jpeg, or png image file")
    always: (e, data) ->
      filesCount -= 1
      filesCount = 0 if filesCount < 0

$(document).on 'click', '#avatar-upload-button', (e) ->
  e.preventDefault()
  $('#user_avatar').trigger 'click'
