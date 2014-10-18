$(document).on 'click', '[data-coupon=show]', (e) -> 
  $(@).parent().find("[data-coupon=form]").show()
  return false

$(document).on 'keydown', '[data-coupon=code]', (e) -> 
  if e.keyCode == 13
    e.preventDefault()
    return false
    
$(document).on 'click', '#coupon_apply', (e) -> 
  button = $(@)
  originalHtml = button.html()
  button.html(button.data("disable-text"))
  $.ajax(
    method: "POST"
    url: button.attr("data-action")
    data: "code=" + button.closest("form").find("[data-coupon=code]").val()
  ).complete (data, textStatus, jqXHR) ->
    button.html(originalHtml)
  return false

$(document).on 'click', '[data-coupon=cancel]', (e) ->
  form = $(@).closest("form")
  form.find("[data-coupon=form]").hide()
  form.find("[data-coupon=code]").val("")
  form.find("[data-coupon=id]").val("")
  form.find("[data-coupon=coupon_price]").hide()
  form.find("[data-coupon=original_price]").show()
  return false  
  
$(document).on 'click', 'form#new_event [data-coupon=cancel]', (e) ->
  selected_option = $(@).closest("form").find("select#event_genre :selected");
  selected_option.text(selected_option.attr("data-text") + " " + selected_option.attr("data-price"));
  selected_option.change();
  
  