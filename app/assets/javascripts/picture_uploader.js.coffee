$(document).on 'ready page:load page:restore', ->
  filesCount = 0

  renderFilesCount = -> 
    $('#file-upload-status .value').text(filesCount)
    if filesCount > 0
      $('#file-upload').addClass 'uploading'
    else
      $('#file-upload').removeClass 'uploading'

  $('#new_picture').fileupload
    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png|GIF|JPE?G|PNG)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        filesCount += 1
        renderFilesCount()
        data.submit()
      else
        alert("#{file.name} is not a gif, jpeg, or png image file")
    always: (e, data) ->
      filesCount -= 1
      filesCount = 0 if filesCount < 0
      renderFilesCount()

$(document).on 'click', '#fileupload-button', (e) ->
  e.preventDefault()
  $('#file').trigger 'click'
