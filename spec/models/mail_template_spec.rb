require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe MailTemplate do
  before(:each) do
    @valid_attributes = {
      :event_id => 1,
      :body => "value for body",
      :subject => "value for subject",
      :name => 'signup_confirmation'
    }
    @template = MailTemplate.new(@valid_attributes)
  end

  it "should create a new instance given valid attributes" do
    MailTemplate.create!(@valid_attributes)
  end
  
  it { should belong_to(:event) }
  
  it { should validate_presence_of(:body) }
  it { should validate_presence_of(:subject) }
  
  %w(signup_confirmation payment_registered ticket_expired ticket_expire_reminder).each do |allowed_value|
    it { should allow_value(allowed_value).for(:name) }
  end
  
  %w(confirmation).each do |disallowed_value|
    it { should_not allow_value(disallowed_value).for(:name) }
  end
  
  it do
    Factory(:mail_template)
    should validate_uniqueness_of(:name).scoped_to(:event_id)
  end
  
  describe "parsing" do
    before do
      time = Time.local(2009, 1, 1)
      Time.stub!(:now).and_return(time)
      @event = mock_model(Event, :name => 'My event', :payment_time => 14)
      @reply = mock_model(EventReply, :event => @event, :name => 'Kalle', :email => "kalle@example.org")
      
    end
    
    %w(body subject).each do |what|
      [
        ["REPLY_NAME", "Kalle"],
        ['EVENT_NAME', 'My event'],
        ['REPLY_LAST_PAYMENT_DATE', '2009-01-15']
      ].each do |variable, result|
        it "should parse {{#{variable}}} for #{what}" do
          @template.send("#{what}=", "{{#{variable}}}")
          @template.send("render_#{what}", @reply).should eql(result)
        end
      end
    end
    
    
  end
end
