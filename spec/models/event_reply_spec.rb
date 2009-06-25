require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventReply do
  before(:each) do
    @event = mock_model(Event)
    @event.stub(:send_mail_for?).with(:signup_confirmation).and_return(false)
    @event.stub!(:send_mail_for?).with(:payment_registered).and_return(false)
    
    @ticket_type = mock_model(TicketType)
    @valid_attributes = {
      :event => @event,
      :name => 'Kalle Anka',
      :email => 'kalle@example.org',
      :ticket_type => @ticket_type
    }
    
    @reply = EventReply.new(@valid_attributes)
  end
  
  it "should be valid" do
    @reply.should be_valid
  end
  
  it { should belong_to(:event) }
  it { should belong_to(:ticket_type) }
  it { should validate_presence_of(:event).with_message('is required') }
  it { should validate_presence_of(:ticket_type).with_message('is required') }
  # This is for making the error messages make more sense...
  it { should have_db_column(:aasm_state).of_type(:string).with_options(:null => false)}
  
  
  xit "should send confirmation mail if there are a mail template with name confirmation"
  
  it "should not send confirmation mail if there aren't any confirmation mail template" do
    EventMailer.should_not_receive(:deliver_signup_confirmation)
    
    @reply.save!
    
  end
  
  it "#paid?" do
    @reply.should_not be_paid
    
    @reply.paid_at = Time.now
    
    @reply.should be_paid
  end
  
  it "should batch save paid" do
    now = Time.now
    Time.stub!(:now).and_return(now)
    
    reply1 = mock_model(EventReply)
    reply1.should_receive(:pay!)
    
    EventReply.stub!(:find).and_return([reply1])
    
    EventReply.pay([1])
  end
  
  it "should not have a paid_at on create" do
    @reply.paid_at.should == nil
  end
  
  it "should set payment date on pay!" do
    now = Time.now
    Time.stub!(:now).and_return(now)
    
    reply = EventReply.create!(@valid_attributes)
    reply.pay!
    
    reply.paid_at.should == now
  end
  
  it "should send payment registration mail when there is a payment_registered mail template" do
    
    ticket_type = TicketType.create!(:name => 'Normal ticket', :price => 10)
    event = Event.create!(:name => "My event")
    event.mail_templates.create!(:body => 'foo', :subject => 'bar', :name => 'payment_registered')
    
    @reply = event.replies.create!(:ticket_type => ticket_type, :name => 'Kalle', :email => 'kalle@example.org')
    
    @event.stub!(:send_mail_for?).with(:payment_registered).and_return(true)
    
    @reply.save!
    
    EventMailer.should_receive(:deliver_payment_registered).with(@reply)
    
    EventReply.pay([@reply.id])
  end
  
  describe "expiry run with 14 days payment time" do
    before do
      @event.stub!(:send_mail_for?).with(:ticket_expired).and_return(true)
      @event.stub!(:expire_unpaid?).and_return(true)

      @event.stub!(:payment_time).and_return(14)
      
      @knatte = EventReply.new(
        @valid_attributes.with(
          :name => 'Knatte',
          :email => 'knatte@example.org'
        )
      )
      @knatte.stub!(:created_at).and_return(20.days.ago)
      @knatte.stub!(:paid?).and_return(true)
      
      @fnatte = EventReply.new(
        @valid_attributes.with(
          :name => 'Fnatte',
          :email => 'fnatte@example.org'
        )
      )
      @fnatte.stub!(:created_at).and_return(21.days.ago)
      
      @tjatte = EventReply.new(
        @valid_attributes.with(
          :name => 'Tjatte',
          :email => 'tjatte@example.org'
        )
      )
      @tjatte.stub!(:created_at).and_return(7.days.ago)
      
      @replies = [@knatte,@fnatte,@tjatte]
      EventReply.stub!(:find).and_return(@replies)
      
      EventMailer.stub!(:deliver_reply_expired_notification)
    end
    
    it "should not expire tickets one week old" do
      @tjatte.should_not_receive(:expire!)
      EventReply.expire_old_unpaid_replies
    end
    
    it "should expire unpaid tickets three weeks old" do
      @fnatte.should_receive(:expire!)
      EventReply.expire_old_unpaid_replies
    end
    
    it "should not expire paid tickets" do
      @knatte.should_not_receive(:expire!)
      EventReply.expire_old_unpaid_replies
    end
    
    it "should send mail to expired" do
      EventMailer.should_receive(:deliver_reply_expired_notification).with(@fnatte)
      @fnatte.expire!
    end
    
    it "should not do expiry process on events without expiry template" do
      @event.stub!(:expire_unpaid?).and_return(false)
      @replies.each {|r| r.should_not_receive(:expire!) }
      EventReply.expire_old_unpaid_replies
    end
  end
end
