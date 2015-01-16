# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

require 'net/smtp'

describe Reply do
  before(:each) do
    @event = mock_model(Event)
    allow(@event).to receive(:send_mail_for?).with(:signup_confirmation).and_return(false)
    allow(@event).to receive(:send_mail_for?).with(:payment_registered).and_return(false)
    allow(@event).to receive(:require_pid?).and_return(false)
    
    @ticket_type = mock_model(TicketType)
    @valid_attributes = {
      :event => @event,
      :name => 'Kalle Anka',
      :email => 'kalle@example.org',
      :ticket_type => @ticket_type,
      guest_state: "unknown",
    }
    
    @reply = Reply.new(@valid_attributes)
  end
  
  it "should be valid" do
    expect(@reply).to be_valid
  end

  # TODO-RAILS3l
  #it { should belong_to(:event) }
  #it { should belong_to(:ticket_type) }
  #it { should validate_presence_of(:event).with_message("måste anges") }
  #it { should validate_presence_of(:ticket_type).with_message("måste anges") }
  #it { should have_and_belong_to_many(:food_preferences) }
  # This is for making the error messages make more sense...
  #it { should have_db_column(:payment_state).of_type(:string).with_options(:null => false)}
  #it { should have_db_column(:guest_state).of_type(:string).with_options(:null => false)}
  
  
  it "#paid?" do
    expect(@reply).not_to be_paid
    
    @reply.paid_at = Time.now
    
    expect(@reply).to be_paid
  end
  
  it "should batch save paid" do
    now = Time.now
    allow(Time).to receive(:now).and_return(now)
    
    reply1 = mock_model(Reply)
    expect(reply1).to receive(:pay!)
    
    allow(Reply).to receive(:find).and_return([reply1])
    
    Reply.pay([1])
  end
  
  it "should not have a paid_at on create" do
    expect(@reply.paid_at).to eq(nil)
  end
  
  it "should set payment date on pay!" do
    now = Time.now
    allow(Time).to receive(:now).and_return(now)
    
    reply = Reply.create!(@valid_attributes)
    reply.pay!
    
    expect(reply.paid_at).to eq(now)
  end
  
  describe "mailings" do
    
    before do
      @ticket_type = TicketType.create!(:name => 'Normal ticket', :price => 10)
      @event = Factory(:event, :name => "My event", :ticket_types => [@ticket_type], :owner => Factory(:my_user))
      @event.mail_templates.create!(:body => 'foo', :subject => 'bar', :name => 'payment_registered')      
    end
    
    it "should send confirmation mail if there are a mail template with name confirmation" do
      stub_event_mailer_methods
      allow(@reply.event).to receive(:send_mail_for?).with(:signup_confirmation).and_return(true)
      
      mock = double("thingie")
      expect(mock).to receive(:signup_confirmation)
      expect(EventMailer).to receive(:delay).and_return(mock)
      
      @reply.save!
    end

    it "should not send confirmation mail if there aren't any confirmation mail template" do
      expect(EventMailer).not_to receive(:send_later).with(:deliver_signup_confirmation)
      
      @reply.save!
      
    end
    
    it "should send payment registration mail when there is a payment_registered mail template" do
      @reply = @event.replies.create!(guest_state: "unknown", :ticket_type => @ticket_type, :name => 'Kalle', :email => 'kalle@example.org')
    
      allow(@event).to receive(:send_mail_for?).with(:payment_registered).and_return(true)
    
      @reply.save!
      
      mock = double("thingie")
      expect(mock).to receive(:payment_registered)
      expect(EventMailer).to receive(:delay).and_return(mock)
      
    
      Reply.pay([@reply.id])
    end
    
    
    [true, "true", "1"].each do |trueish|
      it "should interpret \"#{trueish}\" as true" do
        @reply = @event.replies.new(
          :ticket_type => @ticket_type,
          :name => 'Kalle',
          :email => 'kalle@example.org',
          :send_signup_confirmation => trueish
        )
        expect(@reply.send_signup_confirmation).to eql(true)
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
        expect(@reply.send_signup_confirmation).to eql(false)
      end
    end
    
  end
  
  describe "expiry run with 14 days payment time" do
    before do
      allow(@event).to receive(:send_mail_for?).with(:ticket_expired).and_return(true)
      allow(@event).to receive(:send_mail_for?).with(:ticket_expire_reminder).and_return(true)
      allow(@event).to receive(:expire_unpaid?).and_return(true)

      allow(@event).to receive(:payment_time).and_return(14)
      allow(@event).to receive(:reminder_time).and_return(7)
      
      @knatte = Reply.new(
        @valid_attributes.with(
          :name => 'Knatte',
          :email => 'knatte@example.org'
        )
      )
      allow(@knatte).to receive(:should_be_expired?).and_return(false)
      
      @fnatte = Reply.new(
        @valid_attributes.with(
          :name => 'Fnatte',
          :email => 'fnatte@example.org'
        )
      )
      allow(@fnatte).to receive(:should_be_expired?).and_return(true)
      allow(@fnatte).to receive(:created_at).and_return(21.days.ago)
      
      #@tjatte = Reply.new(
      #  @valid_attributes.with(
      #    :name => 'Tjatte',
      #    :email => 'tjatte@example.org'
      #  )
      #)
      #@tjatte.stub(:created_at).and_return(7.days.ago)
      
      @replies = [@knatte,@fnatte]
      allow(Reply).to receive(:find).and_return(@replies)
      
      stub_event_mailer_methods
    end
    
    it "should send mail to expired" do
      @fnatte.save!
      @fnatte.remind!
      #EventMailer.should_receive(:send_later).with(:deliver_reply_expired_notification, @fnatte)
      @fnatte.expire!
    end
    
    it "should change state to expired" do
      @reply.save!
      @reply.remind!
      @reply.expire!
      expect(@reply.payment_state_name).to eq(:expired)
    end
    
    it "should not expire unreminded replies" do
      allow(@reply).to receive(:payment_state_name).and_return(:new)
      expect {
        @reply.expire!
      }.to raise_error(StateMachine::InvalidTransition)
    end
  end
  
  describe "#should_be_expired?" do
    before do
      @reply = Reply.new(
        @valid_attributes.with(
          :name => 'Knatte',
          :email => 'knatte@example.org'
        )
      )
      
      @reply.save!
      
      allow(@event).to receive(:payment_time).and_return(14)
      allow(@event).to receive(:expire_time_from_reminder).and_return(7)
      stub_event_mailer_methods
    end
    
    RSpec::Matchers.define :be_marked_for_expire do
      match do |reply|
        reply.should_be_expired?
      end
    end
    
    it "should not be expired if cancelled" do
      allow(@reply).to receive(:payment_state).and_return('cancelled')
      expect(@reply).not_to be_marked_for_expire
    end
    
    it "should not be expired if reminded, paid and after pay date" do
      allow(@reply).to receive(:created_at).and_return(21.days.ago)
      @reply.pay!
      
      expect(@reply).not_to be_marked_for_expire
    end
    
    it "should not be expired if before pay date" do
      allow(@reply).to receive(:created_at).and_return(5.days.ago)

      expect(@reply).not_to be_marked_for_expire
    end
    
    it "should not be expired if not reminded, after pay date and unpaid" do
      allow(@reply).to receive(:created_at).and_return(21.days.ago)
      
      expect(@reply).not_to be_marked_for_expire
    end
    
    it "should not be expired if reminded, unpaid and passed pay date, if there havent't gone enough time since reminder" do
      allow(@reply).to receive(:created_at).and_return(21.days.ago)
      
      @reply.remind!
      allow(@reply).to receive(:reminded_at).and_return(5.days.ago)
      
      expect(@reply).not_to be_marked_for_expire
    end
    
    it "should be expired if reminded, unpaid, passed pay date and enough days passed since reminder" do
      allow(@reply).to receive(:created_at).and_return(21.days.ago)
      
      @reply.remind!
      allow(@reply).to receive(:reminded_at).and_return(10.days.ago)
      
      expect(@reply).to be_marked_for_expire
    end
    
    it "should not be expired if cancelled" do
      allow(@reply).to receive(:created_at).and_return(30.days.ago)
      Timecop.freeze(10.days.ago) do
        @reply.remind!
      end

      @reply.cancel!
      
      expect(@reply).not_to be_marked_for_expire
    end
    
    #
    #it "should not be expired unless reminded once"
  end
  
  describe "#should_be_reminded?" do
    
    RSpec::Matchers.define :be_marked_for_reminding do
      match do |reply|
        reply.should_be_reminded?
      end
    end
    
    
    before do
      @reply = Reply.new(
        @valid_attributes.with(
          :name => 'Knatte',
          :email => 'knatte@example.org'
        )
      )
      
      @reply.save!
      
      allow(@event).to receive(:payment_time).and_return(14)
      allow(@reply).to receive(:created_at).and_return(21.days.ago)
      allow(@event).to receive(:expire_time_from_reminder).and_return(5)
      
      stub_event_mailer_methods
    end

    
    it "should not be reminded if cancelled" do
      allow(@reply).to receive(:guest_state).and_return('cancelled')
      expect(@reply).not_to be_marked_for_reminding
    end
    
    it "should not be reminded if expired" do
      allow(@event).to receive(:send_mail_for?).with(:ticket_expired).and_return(true)

      Timecop.freeze(8.days.ago) do
        @reply.remind!
      end

      @reply.expire!

      expect(@reply).not_to be_marked_for_reminding
    end
    
    it "should be reminded if after payment date" do
      expect(@reply).to be_marked_for_reminding
    end
    
    it "should not be reminded if paid" do
      @reply.pay!
      expect(@reply).not_to be_marked_for_reminding
    end
    
    it "should not be reminded if already reminded" do
      @reply.remind!
      
      expect(@reply).not_to be_marked_for_reminding
    end
  end
  
  it "should set reminded at date" do
    stub_event_mailer_methods
    now = Time.now
    allow(Time).to receive(:now).and_return(now)
    
    @reply.remind!
    expect(@reply.reminded_at).not_to be_nil
    expect(@reply.reminded_at.to_s(:db)).to eql(now.to_s(:db))
  end
  
  it "should send reminder letter" do
    # TODO Delayed job
    #EventMailer.should_receive(:send_later).with(:deliver_ticket_expire_reminder, @reply)
    
    #@reply.remind!
  end
  
  it "should save the record even if a mail error occurs (Net::SMTPFatalError)" do
    allow(@event).to receive(:send_mail_for?).with(:signup_confirmation).and_return(true)
    mock_mail = double("Mail")
    allow(mock_mail).to receive(:deliver).and_raise(Net::SMTPFatalError)
    allow(EventMailer).to receive(:signup_confirmation).and_return(mock_mail)
    
    reply = Reply.new(@valid_attributes)
    
    expect(reply.save).to be_truthy
    
  end
  
  it "should save the record even if a mail error occurs (Net::SMTPAuthenticationError" do
    mock_mail = double("Mail")
    allow(mock_mail).to receive(:deliver).and_raise(Net::SMTPAuthenticationError)
    allow(EventMailer).to receive(:signup_confirmation).and_return(mock_mail)
    
    reply = Reply.new(@valid_attributes)
    
    expect(reply.save).to be_truthy
    
  end
  
  it "should flag records that didn't get mail"
  
  #TODO-RAILS3 fixa denna att inte vara shoulda
  #xit "should not require presence of pid without pid requirement on event" do
  #  @reply.should_not validate_presence_of(:pid)
  #end
  
  it "should generate payment reference" do
    allow(@event).to receive(:has_payment_reference?).and_return(true)
    allow(@event).to receive(:ref_prefix).and_return("MyE")
    expect(@reply.payment_reference).to eql("MyE-#{@reply.id}")
  end
  
  describe "with pid requirements" do
    before do
      allow(@event).to receive(:require_pid?).and_return(true)
    end
    it "should validate presence of pid" do
      @reply.pid = nil
      
      expect(@reply).not_to be_valid
      expect(@reply).to have(1).error_on(:pid)
      expect(@reply.errors[:pid]).to include("måste anges på korrekt form (YYMMDD-XXXX)")
    end
    
    it "should accept yyyymmdd-xxxx format and convert to yymmdd-xxxx" do
      @reply.pid = "19841027-0196"
      expect(@reply).to be_valid
      @reply.save!
      expect(@reply.pid).to eql("841027-0196")
    end
    
    it "should accept yymmdd-xxxx format and convert to yymmdd-xxxx" do
      @reply.pid = "841027-0196"
      expect(@reply).to be_valid
      @reply.save!
      expect(@reply.pid).to eql('841027-0196')
    end
    
    it "should accept yyyymmddxxxx format and convert to yymmdd-xxxx" do
      @reply.pid = "198410270196"
      expect(@reply).to be_valid
      @reply.save!
      expect(@reply.pid).to eql('841027-0196')
    end
    
    it "should accept yymmddxxxx format and convert to yymmdd-xxxx" do
      @reply.pid = "8410270196"
      expect(@reply).to be_valid
      @reply.save!
      expect(@reply.pid).to eql('841027-0196')
    end
    
    ["1", "123456789", "123456789012345678"].each do |unaccepted_pid|
      it "should not accept #{unaccepted_pid} as pid" do
        @reply.pid = unaccepted_pid
        expect(@reply).not_to be_valid
        expect(@reply).to have(1).error_on(:pid)
      end
    end
    
  end
  
    
  def stub_event_mailer_methods
    mail_mock = double("Mailer", :deliver => true)
    allow(EventMailer).to receive(:ticket_expire_reminder).and_return(mail_mock)
    allow(EventMailer).to receive(:payment_registered).and_return(mail_mock)
    allow(EventMailer).to receive(:reply_expired_notification).and_return(mail_mock)
  end
end
