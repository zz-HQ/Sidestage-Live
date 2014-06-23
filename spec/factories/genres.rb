FactoryGirl.define do
  
  factory :genre do
    factory :genre_classic do
      name "Classic"
    end
    factory :genre_pop do
      name "Pop"
    end
    factory :genre_dj do
      name "DJ"
    end
    factory :genre_country do
      name "Country"
    end
  end

end
