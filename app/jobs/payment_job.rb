class PaymentJob 
  
  def self.payout_artists
    Deal.dealed.past.charged.not_paid_out.find_each(batch_size: 15) do |deal|
      BalancedWorker.perform_async(:payout_deal, deal.id)
      STDOUT.print '.'; STDOUT.flush
    end 
  end
  
end