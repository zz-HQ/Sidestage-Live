module Profile::Shareable
  extend ActiveSupport::Concern

  
  included do

    SHARE_WITH_FRIEND_COUPONS = { "USD" => "DNBGH15US", "GBP" => "DNBGH15UK", "EUR" => "DNBGH15EU" }

    attr_accessor :friends_emails

  end
  
  def share_with_friends!
    if friends_emails.present?
      friends_emails.split(",").each do |email|
        EmailWorker.perform_async(:share_profile_with_friend, self.id, email)
      end
    end
  end

  def share_with_friend_coupon
    @share_coupon ||= Coupon.active.valid.by_code(SHARE_WITH_FRIEND_COUPONS[currency] || SHARE_WITH_FRIEND_COUPONS["USD"]).first
  end    
  
  #
  # Private
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #  
  
  private
  
end