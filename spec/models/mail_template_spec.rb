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
  
  it "should not be valid with PAYMENT_REFERENCE if the event doesn't have a ref prefix" do
    event = mock_model(Event, :ref_prefix => nil)
    
    @template.event = event
    
    @template.body = "Payment ref is {{PAYMENT_REFERENCE}}."
    
    @template.should_not be_valid
    @template.should have(1).errors_on(:body)
    @template.errors.on(:body).should == "can't have a PAYMENT_REFERENCE without a prefix on the event"
  end
  
  describe "parsing" do
    before do
      time = Time.local(2009, 1, 1)
      Time.stub!(:now).and_return(time)
      @event = mock_model(Event, :name => 'My event', :payment_time => 14)
      @reply = mock_model(Reply,
        :id => 1,
        :event => @event,
        :name => 'Kalle',
        :email => "kalle@example.org",
        :payment_reference => 'MyE-1',
        :ticket_type => mock_model(TicketType, :price => 100))
      
    end
    
    %w(body subject).each do |what|
      [
        ["REPLY_NAME", "Kalle"],
        ['EVENT_NAME', 'My event'],
        ['REPLY_LAST_PAYMENT_DATE', '2009-01-15'],
        ['PAYMENT_REFERENCE', "MyE-1"],
        ['PRICE', '100']
      ].each do |variable, result|
        it "should parse {{#{variable}}} for #{what}" do
          @template.send("#{what}=", "{{#{variable}}}")
          @template.send("render_#{what}", @reply).should eql(result)
        end
      end
    end
    
    
  end
end
