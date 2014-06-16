module Profile::Presentable
  
  def cancellation_policy_for_select
    Profile::CANCELLATION_POLICY.map do |key, value|
      [I18n.translate(value), key]
    end
  end
  
  def cancellation_policy_to_str
    I18n.t(Profile::CANCELLATION_POLICY[cancellation_policy])
  end

  def availability_for_select
    Profile::AVAILABILITY.map do |key, value|
      [I18n.translate(value), key]
    end
  end

  def availability_to_str
    I18n.t(Profile::AVAILABILITY[availability])
  end
  
  def travel_costs_for_select
    Profile::TRAVEL_COSTS.map do |key, value|
      [I18n.translate(value), key]
    end
  end

  def travel_costs_to_str
    I18n.t(Profile::TRAVEL_COSTS[travel_costs])
  end
    
end