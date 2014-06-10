$(document).on 'submit', '[data-form=payment]', (e) ->
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
        form.get(0).submit()
      return

