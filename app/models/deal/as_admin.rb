class Deal::AsAdmin < Deal
  
  #
  # Intance Methods
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  def toggle_payout!
    update_attribute :payed_out, !payed_out?
  end
  
end