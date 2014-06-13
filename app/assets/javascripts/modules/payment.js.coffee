window.App = {} if window.App == undefined
App = window.App

stripeListener = (e, message) ->
  return true if message?
  
  stripeToken = $(@).find("input[name='user[stripe_token]']")
  #if there is no token field at all, then no need to ask stripe for a token
  if stripeToken.length > 0 && stripeToken.val() == ""
    #if nothing entered then maybe it is optional
    if($(@).find("input[data-stripe=number]").val() == "")
      return

    e.preventDefault()

    $(".payment-status").show()
    Stripe.card.createToken $("[data-form=payment]"), (status, response) ->
      if response.error
        console.log(response.error)
        $(".payment-errors").text(response.error.message).show()
        $(".payment-status").hide()
      else
        form = $("[data-form=payment]")
        token = response["id"]
        form.find("input[name='user[stripe_token]']").val(token)
        if(form.attr("remote") == "true")
          $.ajax(method: form.attr("method"), url: form.attr("action"), data: form.serialize())
        else
          form.trigger 'submit', ['done']
      return

App.setStripeListener = ->
  $('[data-form=payment]').off 'submit', stripeListener
  $('[data-form=payment]').on 'submit', stripeListener
