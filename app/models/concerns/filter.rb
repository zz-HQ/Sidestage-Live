module Filter
  extend ActiveSupport::Concern
  
  included do

    def self.filterable(*args)
      @valid_filter_columns = args
      options = args.extract_options!
      
      scope :filter, ->(params) {
        chain = self
        params.each do |k, v|
          if @valid_filter_columns.include?(k.to_sym)
            chain = chain.where(k, v)
          end
        end
        chain
      }
      
    end
    
  end

end