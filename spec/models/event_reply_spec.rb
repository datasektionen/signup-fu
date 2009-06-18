require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventReply do
  before(:each) do
    @event = mock_model(Event)
    @event.stub(:send_mail_for).with(:confirmation).and_return(false)
    @valid_attributes = {
      :event => @event,
      :name => 'Kalle Anka',
      :email => 'kalle@example.org'
    }
    
    @reply = EventReply.new(@valid_attributes)
  end
  
  it "should be valid" do
    @reply.should be_valid
  end
  
  it { should belong_to(:event) }
  it { should validate_presence_of(:event).with_message('is required') }
  
  it "should send confirmation mail if there are a mail template with name confirmation"
  
  it "should not send confirmation mail if there aren't any confirmation mail template" do
    EventMailer.should_not_receive(:deliver_signup_confirmation)
    
    @reply.save!
    
  end
  

end
