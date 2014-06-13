module Payment
  extend ActiveSupport::Concern
  
  included do
  end
  
  def create_stripe_customer(stripe_token, desc)
    begin
      Stripe::Customer.create(card: stripe_token, description: desc)
    rescue Stripe::StripeError => e
      # TODO: Stripe Customer Create Error
      Rails.logger.info "###########################"
      Rails.logger.info e.inspect
      Rails.logger.info "###########################"
    end
  end
  
end