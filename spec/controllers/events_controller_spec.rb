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
      response.should be_redirect
    end
    
    it "sets user to logged in user" do
      sign_in(@user)
      post :create, @valid_params
  
      Event.last.owner.should == @user
    end
  end
end
