module Measurement
  extend ActiveSupport::Concern

  
  included do
    scope :since, ->(since) { where("created_at > ?", since) }
  end
  
end