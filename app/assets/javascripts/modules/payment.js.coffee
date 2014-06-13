window.App = {} if window.App == undefined
App = window.App

stripeListener = (e, message) ->
  return true if message?

  stripeToken = $(@).find("input[name=stripe_token]")
  if stripeToken.length > 0 && stripeToken.val() == ""
    e.preventDefault()

    $(".payment-status").show()
    Stripe.card.createToken $("[data-form=payment]"), (status, response) ->
      if response.error
        $(".payment-errors").text(response.error.message).show()
        $(".payment-status").hide()
      else
        form = $("[data-form=payment]")
        token = response["id"]
        form.find("input[name=stripe_token]").val(token)
        $.ajax(method: form.attr("method"), url: form.attr("action"), data: form.serialize())
        #form.trigger 'submit', ['do it']
      return

App.setStripeListener = ->
  $('[data-form=payment]').off 'submit', stripeListener
  $('[data-form=payment]').on 'submit', stripeListener
