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
  
  Genre.delete_all
  FactoryGirl.create(:genre_classic)
  FactoryGirl.create(:genre_pop)
  FactoryGirl.create(:genre_dj)
  FactoryGirl.create(:genre_country)
    
end
