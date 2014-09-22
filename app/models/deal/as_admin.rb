class Deal::AsAdmin < Deal
  
  #
  # Intance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def toggle_payout!
    update_attribute :paid_out, !paid_out?
  end
  
end