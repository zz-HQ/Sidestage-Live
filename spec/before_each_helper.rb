def before_each
  before(:each) do
    FactoryGirl.create(:us_dollar)  
    FactoryGirl.create(:euro)
  end  
end
