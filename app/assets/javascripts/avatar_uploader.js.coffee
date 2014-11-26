# $(document).on 'ready page:load page:restore', ->
#   filesCount = 0
# 
#   renderUploading = ->
#     if filesCount > 0
#       $(".loader").show()
#     else
#       $(".loader").hide()
# 
#   $('[data-upload=auto]').fileupload
#     add: (e, data) ->
#       types = /(\.|\/)(gif|jpe?g|png|GIF|JPE?G|PNG)$/i
#       file = data.files[0]
#       if types.test(file.type) || types.test(file.name)
#         filesCount += 1
#         renderUploading()
#         data.submit()
#       else
#         alert("#{file.name} is not a gif, jpeg, or png image file")
#     always: (e, data) ->
#       filesCount -= 1
#       filesCount = 0 if filesCount < 0
#       renderUploading()
# 
$(document).on 'click', '.avatar-upload-button', (e) ->
  e.preventDefault()
  $($(this).attr("data-target")).trigger 'click'

$(document).on 'ready page:load page:restore', ->
  $("#cloudinary-direct").fileupload(
    acceptFileTypes: /(\.|\/)(gif|jpe?g|png|GIF|JPE?G|PNG)$/i
    maxFileSize: 5000000 #5MB
    dropZone: "[data-container='dropzone']"
    start: (e) ->
      $(".loader").show()
      return

    progress: (e, data) ->
      #$(".status").text "Uploading... " + Math.round((data.loaded * 100.0) / data.total) + "%"
      return

    fail: (e, data) ->
      $(".loader").hide()
      return
  ).off("cloudinarydone").on "cloudinarydone", (e, data) ->
    $(".loader").hide()
    $("#cloudinary-direct").closest("form").submit()
    return