$(document).on 'ready page:load page:restore', ->
  filesCount = 0
  filesCountFirst = 0

  renderFilesCount = ->
    parts = 100 / filesCountFirst
    part = filesCountFirst - filesCount
    $('#file-upload-status .value').css("width", parts * part + "%")
    if filesCount > 0
      $('#file-upload-status').show()
    else
      $('#file-upload-status').delay(1500).hide(0) # animate({'opacity': 0}, 100)

  $('#new_picture').fileupload
    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png|GIF|JPE?G|PNG)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        filesCountFirst += 1
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