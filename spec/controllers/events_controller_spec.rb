require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventsController do
  describe "POST /events" do
    before do
      @user = Factory(:dkm)
      @valid_params = {:event => Factory.attributes_for(:event)}
      @valid_params[:event][:ticket_types_attributes] = [Factory.attributes_for(:ticket_type)]
    end
    
    it "successfully creates event" do
      sign_in(@user)
      post :create, @valid_params
      expect(response).to be_redirect
    end
    
    it "sets user to logged in user" do
      sign_in(@user)
      post :create, @valid_params
  
      expect(Event.last.owner).to eq(@user)
    end
  end
end
