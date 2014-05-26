require 'spec_helper'

describe Genre, :type => :model do
  
  it "creates translation" do
    translated_genre = Genre.create! :name => "Deutscher Name"
    
    expect(Genre.with_translations(:de).last.name).to eq(translated_genre.name)    
  end
  
end
