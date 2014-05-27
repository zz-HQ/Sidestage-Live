require 'spec_helper'

describe BookingRequest, :type => :model do
  
  describe "Validations" do

    it { should validate_presence_of(:requestor_id) }
    it { should validate_presence_of(:artist_id) }
    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).only_integer }    
    it { should validate_presence_of(:start_at) }

    it "has valid Factory" do
      expect(FactoryGirl.build(:booking_request)).to be_valid
    end
    
  end
  
  describe "Associations" do

    it { should belong_to(:requestor) }
    it { should belong_to(:artist) }
        
  end
  
end
