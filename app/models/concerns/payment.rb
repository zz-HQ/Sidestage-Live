module Payment
  extend ActiveSupport::Concern
  
  included do
  end
  
  def create_stripe_customer(user, desc=nil)
    begin
      Stripe::Customer.create(card: user.stripe_token, description: desc || user.email)
    rescue Stripe::StripeError => e
      # TODO: Stripe Customer Create Error
      User.where(id: user.id).update_all(stripe_log: e.json_body.inspect)
      Rails.logger.info "###########################"
      Rails.logger.info e.inspect
      Rails.logger.info "###########################"
    end
  end
  
end