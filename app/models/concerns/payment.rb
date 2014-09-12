module Payment
  extend ActiveSupport::Concern
  
  included do
  end
  
  def credit_card
    return if balanced_card_id.nil?
    @credit_card ||= CreditCard.new(retrieve_balanced_card)
  end
  
  def retrieve_customer
    begin
      @stripe_customer = nil if balanced_token.present?
      @stripe_customer ||= Balanced::Customer.fetch("/customers/#{balanced_customer_id}")
    rescue Balanced::Error => e
      User.where(id: id).update_all(error_log: e.inspect)
      return [{}]
    end
  end
  
  def retrieve_balanced_card(balanced_card_id)
    begin
      Balanced::Card.fetch("/cards/#{balanced_card_id}")
    rescue Balanced::Error => e
      User.where(id: id).update_all(error_log: e.inspect)
    end
  end

  def destroy_balanced_card
    return true if balanced_card_id.blank?
    begin
      Balanced::Card.fetch("/cards/#{balanced_card_id}").unstore
      update_attribute :balanced_card_id, nil
      return true
    rescue Balanced::Error => e
      errors.add :balanced_card_id, e.extras.values.join(",")
      User.where(id: id).update_all(error_log: e.inspect)
      return false
    end
  end
  
  def create_balanced_card
    begin
      card = Balanced::Card.fetch("/cards/#{balanced_token}")
      card.associate_to_customer(retrieve_customer.href)
      return save_balanced_card!(card)
    rescue Balanced::Error => e
      User.where(id: id).update_all(error_log: e.inspect)
      errors.add :balanced_card_id, e.extras.values.join(",")
      balanced_token = nil
    end
  end
  
  def create_balanced_customer
    begin
      balanced_customer = Balanced::Customer.new(name: name, phone: mobile_nr, email: email)
      balanced_customer.save
      card = Balanced::Card.fetch("/cards/#{balanced_token}")
      card.associate_to_customer(balanced_customer.href)
      return save_balanced_customer!(balanced_customer)
    rescue Balanced::Error => e
      User.where(id: id).update_all(error_log: e.inspect)
      errors.add :balanced_customer_id, e.extras.values.join(",")
      balanced_token = nil
    end
  end

  def charge_deal_customer(customer, deal)
    return true if deal.balanced_debit_id.present?
    return false if customer.balanced_customer_id.nil?
    begin
      price_to_be_charged = deal.price_in_dollor_with_surcharge_in_cents
      debit = retrieve_balanced_card(customer.balanced_card_id).debit(
        :amount => price_to_be_charged,
        :appears_on_statement_as => 'Sidestage',
        :description => "#{customer.name} - #{profile.name}"
      )
      deal.charged_price = price_to_be_charged
      deal.balanced_debit_id = debit.id
      ensure_balanced_charge!
      return true
    rescue Balanced::Error => e
      User.where(id: customer.id).update_all(error_log: e.inspect) 
      deal.errors.add :balanced_debit_id, e.extras.values.join(",")
    end
    return false
    
  end

  def save_balanced_card!(card)
    self.balanced_card_id = card.id
    User.where(id: id).update_all(balanced_card_id: self.balanced_card_id)
    self.balanced_token = nil
    @stripe_customer = nil
    return true
  end
  
  def save_balanced_customer!(customer)
    self.balanced_customer_id = customer.id
    self.balanced_card_id = customer.cards.first.id if customer.cards.first.present?
    User.where(id: id).update_all(balanced_customer_id: self.balanced_customer_id, balanced_card_id: self.balanced_card_id)
    customer.balanced_token = nil
    return true
  end
  
end

