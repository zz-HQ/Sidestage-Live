require 'spec_helper'


describe Account::MobileNumbersController, :type => :controller do
  
   
  
  it "renders show" do
    sign_in(FactoryGirl.create(:user))
    get :show
    expect(response).to render_template(:show)
  end
  
  context "validations" do

    it "validates mobile nr" do
      sign_in(FactoryGirl.create(:user, mobile_nr: nil, mobile_nr_confirmed_at: nil))

      put :update, user_as_mobile_number: { mobile_nr: "0232" }

      expect(assigns(:user).errors).to have_key(:mobile_nr)
      open_last_text_message_for("0232")
      expect(current_text_message).to be_nil
      expect(response).to render_template(:show)
    end

    it "validates confirmation code" do
      sign_in(FactoryGirl.create(:user, mobile_nr: "+49123454567", mobile_nr_confirmed_at: nil))

      put :confirm, user_as_mobile_number: { mobile_confirmation_code: "123" }

      expect(assigns(:user).errors).to have_key(:mobile_confirmation_code)
      open_last_text_message_for "+49123454567"
      expect(current_text_message).to be_nil
      expect(response).to render_template(:show)
    end

  end
  
  it "sends sms verification code" do
    sign_in(FactoryGirl.create(:user, mobile_nr: nil))
    put :update, user_as_mobile_number: { mobile_nr: "+49123454567" }

    open_last_text_message_for "+49123454567"
    expect(current_text_message.body).to include("Sidestage confirmation code:")

  end
  
  it "confirms mobile nr" do
    user = FactoryGirl.create(:user, mobile_nr: "+49123454567", mobile_nr_confirmed_at: nil)
    sign_in(user)
    allow_any_instance_of(User).to receive(:verify_otp).and_return(true)

    put :confirm, user_as_mobile_number: { mobile_confirmation_code: "456" }
    
    expect(user.reload.mobile_nr_confirmed?).to be_truthy
  end
  
end