$(document).on 'click', '#coupon_show', (e) -> 
  $("#coupon_form").show()
  return false

$(document).on 'click', '#coupon_apply', (e) -> 
  button = $(@)
  originalHtml = button.html()
  button.html(button.data("disable-text"))
  $.ajax(
    method: "POST"
    url: button.attr("data-action")
    data: "code=" + button.closest("form").find("#coupon_code").val()
  ).complete (data, textStatus, jqXHR) ->
    button.html(originalHtml)
  return false

$(document).on 'click', '#coupon_cancel', (e) ->
  form = $(@).closest("form")
  form.find("#coupon_form").hide()
  form.find("#coupon_code").val("")
  form.find("#coupon_id").val("")
  form.find("#coupon_price").hide()
  form.find("#coupon_raw_price").show()
  return false  