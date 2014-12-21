FactoryGirl.define do

  factory :picture do
    title "test"
    picture File.open(File.join(Rails.root, 'spec', 'fixtures', 'images', 'example.jpg'))
  end

end
