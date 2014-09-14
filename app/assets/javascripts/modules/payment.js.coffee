window.App = {} if window.App == undefined
App = window.App

balancedCardListener = (e, message) ->
  return true if message?
  
  stripeToken = $(@).find("input[name*='balanced_token']")
  #if there is no token field at all, then no need to ask stripe for a token
  if stripeToken.length > 0 && stripeToken.val() == ""
    e.preventDefault()
    $(".payment-status").show()
    $(".payment-errors").hide()

    # exp_date = $(@).find("[data-stripe='expiry']").val()
    # cardValues = 
    #   number: $(@).find("[data-stripe='number']").val()
    #   cvc: $(@).find("[data-stripe='cvc']").val()
    #   exp_month: exp_date.split("/")[0] || ""
    #   exp_year: exp_date.split("/")[1] || ""

    payload =
      number: $("#credit_card_number").val()
      expiration_month: $("#credit_card_ex_month").val()
      expiration_year: $("#credit_card_ex_year").val()
      cvv: $("#credit_card_cvc").val()
    balanced.card.create(payload, creditCardCallback);      
    #somehow the following line is needed  
    return false

creditCardCallback = (response) ->
  if response.errors
    $(".payment-errors").text(response.errors[0].description).show()
    $(".payment-status").hide()
    return false
  else
    form = $("[data-form=payment]")
    token = response.cards[0].id
    form.find("input[name*='balanced_token']").val(token)
    if(form.attr("data-remote") == "true")
      $.ajax(method: form.attr("method"), url: form.attr("action"), data: form.serialize())
    else
      form.trigger 'submit', ['done']
  return
  

App.setBalancedCardListener = ->  
  #$('[data-form=payment]').off 'submit', balancedCardListener
  #$('[data-form=payment]').on 'submit', balancedCardListener
#TODO: remove the following two lines after turbolinks is activated again
$(document).on 'submit', '[data-form=payment]', balancedCardListener

################### Bank Account ################

balancedBankAccountListener = (e, message) ->
  return true if message?
  balancedToken = $(@).find("input[name*='balanced_token']")
  if balancedToken.length > 0 && balancedToken.val() == ""
    e.preventDefault()
  
    $(".payment-status").show()
    $(".payment-errors").hide()
  
    payload =
      name: $("#profile_payout_name").val()
      routing_number: $("#profile_routing_number").val()
      account_number: $("#profile_account_number").val()
  
    balanced.bankAccount.create payload, bankAccountCallBack
    return false

bankAccountCallBack = (response) ->
  if response.errors
    $(".payment-errors").text(response.errors[0].description).show()
    $(".payment-status").hide()
  else
    form = $("[data-form='bank_account']")
    token = response.bank_accounts[0].id
    form.find("input[name*='balanced_token']").val(token)
    if(form.attr("data-remote") == "true")
      $.ajax(method: form.attr("method"), url: form.attr("action"), data: form.serialize())
    else
      form.trigger 'submit', ['done']
  return

App.balancedBankAccountListener = ->  

$(document).on 'submit', '[data-form=bank_account]', balancedBankAccountListener

################### End Bank Account ################

$(document).on 'keyup', "input[type=text][data-surcharge]", (e) ->
  price = parseInt($(@).val())
  surcharged = price + ( price * ($(@).attr("data-surcharge") / 100.0) )
  surcharged = (if isNaN(surcharged) then "" else surcharged.toFixed(0))
  $($(@).attr("data-surcharged-label")).html(surcharged)
