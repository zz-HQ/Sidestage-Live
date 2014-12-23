$(document).on 'ready page:load page:restore', ->
  filesCount = 0

  renderUploading = ->
    if filesCount > 0
      $(".loader").show()
    else
      $(".loader").hide()

  $('[data-upload=auto]').fileupload
    add: (e, data) ->
      types = /(\.|\/)(gif|jpe?g|png|GIF|JPE?G|PNG)$/i
      file = data.files[0]
      if types.test(file.type) || types.test(file.name)
        filesCount += 1
        renderUploading()
        data.submit()
      else
        alert("#{file.name} is not a gif, jpeg, or png image file")
    always: (e, data) ->
      filesCount -= 1
      filesCount = 0 if filesCount < 0
      renderUploading()

$(document).on 'click', '.avatar-upload-button', (e) ->
  e.preventDefault()
  $('.file').trigger 'click'




dataURLtoBlob = (dataURL) ->
  # Decode the dataURL
  binary = atob(dataURL.split(",")[1])
  # Create 8-bit unsigned array
  array = []
  i = 0
  while i < binary.length
    array.push binary.charCodeAt(i)
    i++
  # Return our Blob object
  new Blob([new Uint8Array(array)],
    type: "image/png"
  )
  
$(document).on 'click', '.avatar-upload-button', (e) ->
  e.preventDefault()
  dataURL = $(".cropme img").attr("src") #mycanvas.toDataURL("image/png;base64;")
  file = dataURLtoBlob(dataURL)
  fd = new FormData()
  fd.append "user[avatar]", file
  $.ajax
    url: "/account/personal/upload_avatar"
    type: "PATCH"
    data: fd
    processData: false
    contentType: false

  return
