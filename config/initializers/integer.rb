class Integer

  def self.surcharge_base
    ENV["surcharge"]
  end
  
  def with_surcharge
    (self + surcharge).round
  end
  
  def surcharge
    self * (Integer.surcharge_base.to_i / 100.0)
  end
  
end

class NilClass
  def with_surcharge
    self
  end
end