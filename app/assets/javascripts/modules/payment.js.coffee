$("[data-form=payment]").submit (e) ->
  return if $(this).find("input[name=stripe_token]").val() != ""
  e.preventDefault()
  $(".payment-status").show()
  Stripe.card.createToken $("[data-form=payment]"), stripeResponseHandler
  false

stripeResponseHandler = (status, response) ->
  if response.error
    $(".payment-errors").text(response.error.message).show()
    $(".payment-status").hide()
  else
    form = $("[data-form=payment]")
    token = response["id"]
    form.find("input[name=stripe_token]").val(token)
    form.get(0).submit()
  return