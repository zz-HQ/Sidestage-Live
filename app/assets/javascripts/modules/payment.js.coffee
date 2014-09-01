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
    $(".payment-errors").hide()

    # exp_date = $(@).find("[data-stripe='expiry']").val()
    # cardValues = 
    #   number: $(@).find("[data-stripe='number']").val()
    #   cvc: $(@).find("[data-stripe='cvc']").val()
    #   exp_month: exp_date.split("/")[0] || ""
    #   exp_year: exp_date.split("/")[1] || ""

    Stripe.card.createToken $("[data-form=payment]"), createTokenCallback
    #somehow the following line is needed  
    return false

createTokenCallback = (status, response) ->
  if response.error
    $(".payment-errors").text(response.error.message).show()
    $(".payment-status").hide()
    return false
  else
    form = $("[data-form=payment]")
    token = response["id"]
    form.find("input[name*='stripe_token']").val(token)
    if(form.attr("data-remote") == "true")
      $.ajax(method: form.attr("method"), url: form.attr("action"), data: form.serialize())
    else
      form.trigger 'submit', ['done']
  return
  

App.setStripeListener = ->  
  #$('[data-form=payment]').off 'submit', stripeListener
  #$('[data-form=payment]').on 'submit', stripeListener
  
#TODO: remove the following two lines after turbolinks is activated again
$(document).on 'submit', '[data-form=payment]', stripeListener

$(document).on 'keyup', "input[type=text][data-surcharge]", (e) ->
  price = parseInt($(@).val())
  surcharged = price + ( price * ($(@).attr("data-surcharge") / 100.0) )
  surcharged = (if isNaN(surcharged) then "" else surcharged.toFixed(0))
  $($(@).attr("data-surcharged-label")).html(surcharged)
