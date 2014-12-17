FactoryGirl.define do
  
  factory :genre do
    factory :genre_classic do
      id 1
      name "Classic"
    end
    factory :genre_pop do
      id 21
      name "Pop"
    end
    factory :genre_dj do
      id 151
      name "DJ"
    end
    factory :genre_country do
      name "Country"
    end
  end

end
