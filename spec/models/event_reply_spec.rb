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
  it { should validate_presence_of(:event).with_message("can't be blank") }
  it { should validate_presence_of(:ticket_type).with_message("can't be blank") }
  it { should have_and_belong_to_many(:food_preferences) }
  # This is for making the error messages make more sense...
  it { should have_db_column(:payment_state).of_type(:string).with_options(:null => false)}
  it { should have_db_column(:guest_state).of_type(:string).with_options(:null => false)}
  
  
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
  
  describe "mailings" do
    
    before do
      @ticket_type = TicketType.create!(:name => 'Normal ticket', :price => 10)
      @event = Factory(:event, :name => "My event", :ticket_types => [@ticket_type])
      @event.mail_templates.create!(:body => 'foo', :subject => 'bar', :name => 'payment_registered')      
    end
    
    it "should send confirmation mail if there are a mail template with name confirmation" do
      @reply.event.stub!(:send_mail_for?).with(:signup_confirmation).and_return(true)
      
      EventMailer.should_receive(:deliver_signup_confirmation)
      
      @reply.save!
    end

    it "should not send confirmation mail if there aren't any confirmation mail template" do
      EventMailer.should_not_receive(:deliver_signup_confirmation)
      
      @reply.save!
      
    end
    
    it "should send payment registration mail when there is a payment_registered mail template" do
      @reply = @event.replies.create!(:ticket_type => @ticket_type, :name => 'Kalle', :email => 'kalle@example.org')
    
      @event.stub!(:send_mail_for?).with(:payment_registered).and_return(true)
    
      @reply.save!
    
      EventMailer.should_receive(:deliver_payment_registered).with(@reply)
    
      EventReply.pay([@reply.id])
    end
    
    # For use in REST-API
    it "should not send signup confirmation mail if send_signup_confirmation is false" do
      EventMailer.should_not_receive(:deliver_signup_confirmation)
      
      @reply = @event.replies.new(
        :ticket_type => @ticket_type,
        :name => 'Kalle',
        :email => 'kalle@example.org',
        :send_signup_confirmation => "false"
      )
      @reply.event.stub!(:send_mail_for?).with(:signup_confirmation).and_return(true)
      
      @reply.save!
    end
    
    [true, "true", "1"].each do |trueish|
      it "should interpret \"#{trueish}\" as true" do
        @reply = @event.replies.new(
          :ticket_type => @ticket_type,
          :name => 'Kalle',
          :email => 'kalle@example.org',
          :send_signup_confirmation => trueish
        )
        @reply.send_signup_confirmation.should eql(true)
      end
    end
    
    [false, "false", "0"].each do |falseish|
      it "should interpret \"#{falseish}\" as false" do
        @reply = @event.replies.new(
          :ticket_type => @ticket_type,
          :name => 'Kalle',
          :email => 'kalle@example.org',
          :send_signup_confirmation => falseish
        )
        @reply.send_signup_confirmation.should eql(false)
      end
    end
    
  end
  
  describe "expiry run with 14 days payment time" do
    before do
      @event.stub!(:send_mail_for?).with(:ticket_expired).and_return(true)
      @event.stub!(:send_mail_for?).with(:ticket_expire_reminder).and_return(true)
      @event.stub!(:expire_unpaid?).and_return(true)

      @event.stub!(:payment_time).and_return(14)
      @event.stub!(:reminder_time).and_return(7)
      
      @knatte = EventReply.new(
        @valid_attributes.with(
          :name => 'Knatte',
          :email => 'knatte@example.org'
        )
      )
      @knatte.stub!(:should_be_expired?).and_return(false)
      
      @fnatte = EventReply.new(
        @valid_attributes.with(
          :name => 'Fnatte',
          :email => 'fnatte@example.org'
        )
      )
      @fnatte.stub!(:should_be_expired?).and_return(true)
      @fnatte.stub!(:created_at).and_return(21.days.ago)
      
      #@tjatte = EventReply.new(
      #  @valid_attributes.with(
      #    :name => 'Tjatte',
      #    :email => 'tjatte@example.org'
      #  )
      #)
      #@tjatte.stub!(:created_at).and_return(7.days.ago)
      
      @replies = [@knatte,@fnatte]
      EventReply.stub!(:find).and_return(@replies)
      
      EventMailer.stub!(:deliver_reply_expired_notification)
      EventMailer.stub!(:deliver_ticket_expire_reminder)
    end
    
    it "should not expire tickets that should not be expired" do
      @knatte.should_not_receive(:expire)
      @fnatte.stub!(:expire)
      EventReply.expire_old_unpaid_replies
    end
    
    it "should expire unpaid tickets that should be expired" do
      @fnatte.should_receive(:expire)
      EventReply.expire_old_unpaid_replies
    end
    
    it "should send mail to expired" do
      @fnatte.save!
      @fnatte.remind!
      EventMailer.should_receive(:deliver_reply_expired_notification).with(@fnatte)
      @fnatte.expire!
    end
    
    it "should not do expiry process on events without expiry template" do
      @event.stub!(:expire_unpaid?).and_return(false)
      @replies.each {|r| r.should_not_receive(:expire) }
      EventReply.expire_old_unpaid_replies
    end
    
    it "should change state to expired" do
      @reply.save!
      @reply.remind!
      @reply.expire!
      @reply.payment_state_name.should == :expired
    end
    
    it "should not expire unreminded replies" do
      @reply.stub!(:payment_state_name).and_return(:new)
      lambda {
        @reply.expire!
      }.should raise_error(StateMachine::InvalidTransition)
    end
  end
  
  describe "#should_be_expired?" do
    before do
      @reply = EventReply.new(
        @valid_attributes.with(
          :name => 'Knatte',
          :email => 'knatte@example.org'
        )
      )
      
      @reply.save!
      
      @event.stub!(:payment_time).and_return(14)
      @event.stub!(:expire_time_from_reminder).and_return(7)
      EventMailer.stub!(:deliver_ticket_expire_reminder)
    end
    
    Spec::Matchers.define :be_marked_for_expire do
      match do |reply|
        reply.should_be_expired?
      end
    end
    
    
    it "should not be expired if reminded, paid and after pay date" do
      @reply.stub!(:created_at).and_return(21.days.ago)
      @reply.pay!
      
      @reply.should_not be_marked_for_expire
    end
    
    it "should not be expired if before pay date" do
      @reply.stub!(:created_at).and_return(5.days.ago)

      @reply.should_not be_marked_for_expire
    end
    
    it "should not be expired if not reminded, after pay date and unpaid" do
      @reply.stub!(:created_at).and_return(21.days.ago)
      
      @reply.should_not be_marked_for_expire
    end
    
    it "should not be expired if reminded, unpaid and passed pay date, if there havent't gone enough time since reminder" do
      @reply.stub!(:created_at).and_return(21.days.ago)
      
      @reply.remind!
      @reply.stub!(:reminded_at).and_return(5.days.ago)
      
      @reply.should_not be_marked_for_expire
    end
    
    it "should be expired if reminded, unpaid, passed pay date and enough days passed since reminder" do
      @reply.stub!(:created_at).and_return(21.days.ago)
      
      @reply.remind!
      @reply.stub!(:reminded_at).and_return(10.days.ago)
      
      @reply.should be_marked_for_expire
    end
    #
    #it "should not be expired unless reminded once"
  end
  
  describe "#should_be_reminded?" do
    
    Spec::Matchers.define :be_marked_for_reminding do
      match do |reply|
        reply.should_be_reminded?
      end
    end
    
    
    before do
      @reply = EventReply.new(
        @valid_attributes.with(
          :name => 'Knatte',
          :email => 'knatte@example.org'
        )
      )
      
      @reply.save!
      
      @event.stub!(:payment_time).and_return(14)
      @reply.stub!(:created_at).and_return(21.days.ago)
      @event.stub!(:expire_time_from_reminder).and_return(5)
      
      EventMailer.stub!(:deliver_ticket_expire_reminder)
    end
    
    it "should be reminded if after payment date" do
      @reply.should be_marked_for_reminding
    end
    
    it "should not be reminded if paid" do
      @reply.pay!
      @reply.should_not be_marked_for_reminding
    end
    
    it "should not be reminded if already reminded" do
      @reply.remind!
      
      @reply.should_not be_marked_for_reminding
    end
  end

  describe "reminder runs!" do
    before do
      @reply = EventReply.new(
        @valid_attributes.with(
          :name => 'Knatte',
          :email => 'knatte@example.org'
        )
      )
      
      @reply.save!
      
      @event.stub!(:payment_time).and_return(14)
      EventMailer.stub!(:deliver_ticket_expire_reminder)
    end
    
    it "should change state to reminded" do
      @reply.remind!
      @reply.payment_state_name.should == :reminded
    end
    
    it "should set reminded at date" do
      now = Time.now
      Time.stub!(:now).and_return(now)
      
      @reply.remind!
      @reply.reminded_at.should_not be_nil
      @reply.reminded_at.to_s(:db).should eql(now.to_s(:db))
    end
    
    it "should send reminder letter" do
      EventMailer.should_receive(:deliver_ticket_expire_reminder)
      
      @reply.remind!
    end
    
    it "should remind replies that should be remindeded...." do
      @event.stub!(:expire_unpaid?).and_return(true)
      
      @reply.stub!(:should_be_reminded?).and_return(true)
      reply2 = EventReply.new(
        @valid_attributes.with(
          :name => 'Knatte',
          :email => 'knatte@example.org'
        )
      )
      
      reply2.stub!(:should_be_reminded?).and_return(false)
      
      EventReply.stub!(:all).and_return([reply2, @reply])
      
      @reply.should_receive(:remind!)
      
      EventReply.remind_old_unpaid_replies
    end
  end
  
  it "should save the record even if a mail error occurs (Net::SMTPFatalError)" do
    @event.stub(:send_mail_for?).with(:signup_confirmation).and_return(true)
    EventMailer.stub!(:deliver_signup_confirmation).and_raise(Net::SMTPFatalError)
    
    reply = EventReply.new(@valid_attributes)
    
    reply.save.should be_true
    
  end
  
  it "should save the record even if a mail error occurs (Net::SMTPAuthenticationError" do
    @event.stub(:send_mail_for?).with(:signup_confirmation).and_return(true)
    EventMailer.stub!(:deliver_signup_confirmation).and_raise(Net::SMTPAuthenticationError)
    
    reply = EventReply.new(@valid_attributes)
    
    reply.save.should be_true
    
  end
  
  it "should flag records that didn't get mail"
  
end
