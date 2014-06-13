window.App = {} if window.App == undefined
App = window.App

stripeListener = (e, message) ->
  return true if message?
  e.preventDefault()

  if $(@).find("input[name=stripe_token]").val() == ""
    $(".payment-status").show()

    Stripe.card.createToken $("[data-form=payment]"), (status, response) ->
      if response.error
        $(".payment-errors").text(response.error.message).show()
        $(".payment-status").hide()
      else
        form = $("[data-form=payment]")
        token = response["id"]
        form.find("input[name=stripe_token]").val(token)
        form.trigger 'submit', ['do it']
      return

App.setStripeListener = ->
  $('#new_deal').off 'submit', stripeListener
  $('#new_deal').on 'submit', stripeListener
