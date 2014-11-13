module Profile::Presentable
  
  def location_without_country
    regions = location.to_s.split(",")
    regions.pop
    regions.blank? ? location : regions.map(&:strip).join(", ")
  end
  
end