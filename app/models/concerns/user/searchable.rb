module User::Searchable
  extend ActiveSupport::Concern

  included do
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks

    settings analysis: {
         filter: {
            autocomplete_filter: {
               type: "edge_ngram",
               min_gram: 3,
               max_gram: 20
            }
         },
         analyzer: {
            autocomplete: {
               type: :custom,
               tokenizer: :standard,
               filter: [
                  :lowercase,
                  :autocomplete_filter
               ]
            }
         }
      }

    mapping _all: { index_analyzer: :autocomplete, search_analyzer: :standard } do      
      indexes :mobile_nr, index: :not_analyzed
      indexes :currency, include_in_all: false
      indexes :id, include_in_all: false
      indexes :artist?, include_in_all: false
      indexes :avatar_mini_url, index: :not_analyzed, include_in_all: false
      indexes :profile do
        indexes :id, include_in_all: false
        indexes :name, include_in_all: true
        indexes :title, include_in_all: true
        indexes :location, include_in_all: false
        indexes :published?, include_in_all: false
      end
    end
    
    def as_indexed_json(options={})
      as_json methods: [:artist?, :avatar_mini_url],
        only: [:id, :email, :full_name, :mobile_nr, :currency],
        include: {
          profile: { methods: [:published?], only: [:id, :slug, :name, :title, :location] }
        }
    end
    
  end
  
  
end