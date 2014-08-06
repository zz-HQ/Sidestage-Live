module Payment
  extend ActiveSupport::Concern
  
  included do
  end
  
  def credit_card
    return if stripe_card_id.nil?
    @credit_card ||= CreditCard.from_stripe_customer(retrieve_customer)
  end
  
  def retrieve_customer
    begin
      @stripe_customer = nil if stripe_token.present?
      @stripe_customer ||= Stripe::Customer.retrieve(stripe_customer_id)
    rescue Stripe::StripeError => e
      User.where(id: id).update_all(error_log: e.json_body.inspect)
      return [{}]
    end
  end

  def destroy_stripe_card
    return true if stripe_card_id.blank?
    begin
      retrieve_customer.cards.retrieve(stripe_card_id).delete
      User.where(id: id).update_all(stripe_card_id: nil)
      return true
    rescue Stripe::StripeError => e
      errors.add :stripe_card_id, e.json_body[:error][:message]
      User.where(id: id).update_all(error_log: e.json_body.inspect)
      return false
    end
  end
  
  def create_stripe_card
    begin
      return save_stripe_card!(retrieve_customer.cards.create(card: stripe_token))
    rescue Stripe::StripeError => e
      User.where(id: id).update_all(error_log: e.json_body.inspect)
      errors.add :stripe_card_id, e.json_body[:error][:message]
      stripe_token = nil
    end
  end
  
  def create_stripe_customer
    begin
      return save_stripe_customer!(Stripe::Customer.create(card: stripe_token, description: email))
    rescue Stripe::StripeError => e
      User.where(id: id).update_all(error_log: e.json_body.inspect)
      errors.add :stripe_customer_id, e.json_body[:error][:message]
      stripe_token = nil
    end
  end

  def charge_deal_customer(customer, deal)
    return true if deal.stripe_charge_id.present?
    return false if customer.stripe_customer_id.nil?
    begin
      charge = Stripe::Charge.create(
        :amount => deal.price_with_surcharge_in_cents,
        :currency => deal.currency,
        :customer => customer.stripe_customer_id,
        :description => "Deal #{customer.name}"
      )
      deal.charged_price = deal.price_with_surcharge_in_cents
      deal.stripe_charge_id = charge.id
      ensure_stripe_charge!
      return true
    rescue Stripe::StripeError => e
      User.where(id: customer.id).update_all(error_log: e.json_body.inspect) 
      deal.errors.add :stripe_charge_id, e.json_body[:error][:message] 
    end
    return false
    
  end

  def save_stripe_card!(card)
    self.stripe_card_id = card.id
    User.where(id: id).update_all(stripe_card_id: self.stripe_card_id)
    self.stripe_token = nil
    @stripe_customer = nil
    return true
  end
  
  def save_stripe_customer!(customer)
    self.stripe_customer_id = customer.id
    self.stripe_card_id = customer.cards.first.id
    User.where(id: id).update_all(stripe_customer_id: self.stripe_customer_id, stripe_card_id: self.stripe_card_id)
    customer.stripe_token = nil
    return true
  end
  
end

