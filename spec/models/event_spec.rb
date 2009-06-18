require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event do
  before do
    @valid_params = {
      :name => "My event"
    }
    @event = Event.new(@valid_params)
    
  end
  
  it { should have_many(:mail_templates) }
  
  it "should be full if it has more than max_guest guests" do
    event = Event.create!(:max_guests => 1)
    event.replies.create!(:name => 'Kalle', :email => 'kalle@example.org')
    
    event.should be_full
  end
  
  it "should check if it has mailtemplate by name" do
    @event.send_mail_for(:confirmation).should eql(false)
  end
  
  it "should fetch mail templates by name" do
    @event.save!
    confirmation_template = @event.mail_templates.create!(:name => 'confirmation')
    
    @event.mail_templates.by_name(:confirmation).should eql(confirmation_template)
  end
  
end