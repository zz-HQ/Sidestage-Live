window.App = {} if window.App == undefined
App = window.App

stripeListener = (e, message) ->
  return true if message?
  
  stripeToken = $(@).find("input[name*='stripe_token']")
  #if there is no token field at all, then no need to ask stripe for a token
  if stripeToken.length > 0 && stripeToken.val() == ""
    #return if optional and nothing entered
    if($(@).attr("data-optional") == "true")
      if($(@).find("input[data-stripe=number]").val() == "")
        return

    e.preventDefault()
    $(".payment-status").show()
    Stripe.card.createToken $("[data-form=payment]"), (status, response) ->
      if response.error
        $(".payment-errors").text(response.error.message).show()
        $(".payment-status").hide()
      else
        form = $("[data-form=payment]")
        token = response["id"]
        form.find("input[name*='stripe_token']").val(token)
        if(form.attr("data-remote") == "true")
          $.ajax(method: form.attr("method"), url: form.attr("action"), data: form.serialize())
        else
          form.trigger 'submit', ['done']
      return
    #somehow the following line is needed  
    return false
App.setStripeListener = ->
  $('[data-form=payment]').off 'submit', stripeListener
  $('[data-form=payment]').on 'submit', stripeListener


$(document).on 'blur', "input[name='profile[price]']", (e) ->
  price = parseInt($(@).val())
  surcharged = price + ( price * ($(@).attr("data-surcharge") / 100.0) )
  surcharged = (if isNaN(surcharged) then "" else surcharged.toFixed(0))
  $("#profile_surcharged_price").html(surcharged)
