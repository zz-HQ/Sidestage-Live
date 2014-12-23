module Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model

    # mapping do
    # end

    # def self.search(query)
    # end

    def as_indexed_json(options={})
      as_json methods: eval("#{self.class.name}::AS_SEARCHABLE_METHODS"), only: eval("#{self.class.name}::AS_SEARCHABLE_JSON"), include: eval("#{self.class.name}::AS_SEARCHABLE_INCLUDES")
    end

  end
  
  
end