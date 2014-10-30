module Filter
  extend ActiveSupport::Concern
  
  included do

    def self.filterable(*args)
      valid_filter_columns = args
      assocs = args.extract_options!
      
      scope :filter, ->(params) {
        chain = self
        params.each do |k, v|
          if valid_filter_columns.include?(k.to_sym)
            chain = chain.where(k.to_sym => v) unless self.columns_hash[k].type == :integer && v.blank?
          elsif assocs.keys.include?(k.to_sym)
            chain = chain.where("#{assocs[k.to_sym]} = ?", v) unless v.blank?
          end
        end
        chain
      }
      
    end
    
  end

end