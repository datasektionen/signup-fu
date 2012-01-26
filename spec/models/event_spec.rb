# encoding: utf-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Event do
  before do
    ticket_type = Factory(:ticket_type)
    @valid_params = {
      :name => "My event",
      :ticket_types => [ticket_type],
      :template => 'default',
      :date => 20.days.from_now,
      :deadline => 10.days.from_now,
      :owner => Factory(:my_user),
      :slug => 'hamster'
    }
    @event = Event.new(@valid_params)
    
  end
    
  it "should not allow deadline after date" do
    @event = Event.new(@valid_params.with(
      :deadline => 10.days.from_now, 
      :date => 5.days.from_now
    ))
    
    @event.should_not be_valid
  end
  
  it "should not accept ticket_expiry without ticket_expire_reminder" do
    event = Event.new(@valid_params)
    event.mail_templates << MailTemplate.new(:name => 'ticket_expired')
    
    event.should_not be_valid
    event.errors[:base].should include("You can't have ticket_expiry without ticket_expire_reminder")
    
  end
  
  it "should not accept ticket_expire_reminder without ticket_expiry" do
    event = Event.new(@valid_params)
    event.mail_templates << MailTemplate.new(:name => 'ticket_expire_reminder')
    
    event.should_not be_valid
    event.errors[:base].should include("You can't have ticket_expire_reminder without ticket_expiry")
  end
  
  it "should require payment time if ticket_expiry" do
    event = Event.new(@valid_params.with(:expire_time_from_reminder => 10))
    event.mail_templates << MailTemplate.new(:name => 'ticket_expired')
    event.mail_templates << MailTemplate.new(:name => 'ticket_expire_reminder')
    
    event.should_not be_valid
    event.should have(1).error_on(:payment_time)
  end
  
  it "should require reminder time if ticket_expiry" do
    event = Event.new(@valid_params.with(:payment_time => 10))
    event.mail_templates << MailTemplate.new(:name => 'ticket_expired')
    event.mail_templates << MailTemplate.new(:name => 'ticket_expire_reminder')
    
    event.should_not be_valid
    event.should have(1).error_on(:expire_time_from_reminder)
  end
  
  it "should not be valid with a expiry and no payment time" do
    event = Event.new(@valid_params.with(:expire_time_from_reminder => 10))
    event.mail_templates << MailTemplate.new(:name => 'ticket_expired')
    event.mail_templates << MailTemplate.new(:name => 'ticket_expire_reminder')
    event.should_not be_valid
    event.should have(1).error_on(:payment_time)
  end
  
  it "should be full if it has more than max_guest guests" do
    event = Event.create!(@valid_params.with(:max_guests => 1))
    event.replies.create!(:name => 'Kalle', :email => 'kalle@example.org', :ticket_type => mock_model(TicketType))
    
    event.should be_full
  end
  
  it "should not be full with max_guests = 1 and one cancelled reply" do
    event = Event.create!(@valid_params.with(:max_guests => 1))
    reply = event.replies.create!(:name => 'Kalle', :email => 'kalle@example.org', :ticket_type => mock_model(TicketType))
    reply.cancel!
    
    event.should_not be_full
    
  end
  
  it "should expire unpaid if it has a template and a payment time" do
    @event = Event.new(@valid_params.with(:payment_time => 10))
    template = Factory(:mail_template, :event => @event, :name => 'ticket_expired')
    
    @event.expire_unpaid?.should be_true
  end
  
  it "should not expire unpaid if it has no template" do
    @event = Event.new(@valid_params.with(:payment_time => 10))
    
    @event.expire_unpaid?.should be_false
  end
  
  
  it "should expire unpaid if it has no payment time" do
    @event = Event.new(@valid_params.with(:payment_time => nil))
    template = Factory(:mail_template, :event => @event, :name => 'ticket_expired')
    
    @event.expire_unpaid?.should be_false
  end
  
  
  it "should check if it has mailtemplate by name" do
    @event.send_mail_for?(:signup_confirmation).should eql(false)
  end
  
  it "should send_mail_for?(:signup_confirmation) if there are a signup confirmation template" do
    @event.save!
    @event.mail_templates.create!(:name => 'signup_confirmation', :body => 'body', :subject => 'subject')
    @event.send_mail_for?(:signup_confirmation).should eql(true)
  end
  
  it "should fetch mail templates by name" do
    @event.save!
    confirmation_template = Factory(:mail_template, :event => @event, :name => 'signup_confirmation')
    
    @event.mail_templates.by_name(:signup_confirmation).should eql(confirmation_template)
  end
  
  it "should have a has_terms?" do
    @event.stub!(:terms).and_return(nil)
    @event.has_terms?.should eql(false)
    
    @event.stub!(:terms).and_return("here be legal stuff")
    @event.has_terms?.should eql(true)
  end
  
  it "should remind replies that should be remindeded...." do
    
    Event.stub!(:find).with(@event.id).and_return(@event)
    
    @event.stub!(:expire_unpaid?).and_return(true)
    
    unpaid_old_reply = mock_model(Reply, :event => @event)
    unpaid_old_reply.stub!(:should_be_reminded?).and_return(true)
    reply2 = mock_model(Reply, :event => @event)
    reply2.stub!(:should_be_reminded?).and_return(false)
    
    @event.stub!(:replies).and_return([unpaid_old_reply, reply2])
    
    unpaid_old_reply.should_receive(:remind!)
    
    ReminderRun.new(@event.id).perform
  end
  
  describe "the expiration process" do
    it "should not expire tickets that should not be expired" do
      Event.stub!(:find).with(@event.id).and_return(@event)
      @event.stub!(:expire_unpaid?).and_return(true)
      
      reply_that_shall_not_expire = mock_model(Reply, :event => @event, :should_be_expired? => false)
      reply_that_shall_expire = mock_model(Reply, :event => @event, :should_be_expired? => true)
      @event.stub!(:replies).and_return([reply_that_shall_expire, reply_that_shall_not_expire])
      
      reply_that_shall_not_expire.should_not_receive(:expire)
      reply_that_shall_expire.should_receive(:expire)
      
      ExpiryRun.new(@event.id).perform
    end
  end
  
  it "must specify an return address if any email template is used" do
    @event.mail_templates << Factory(:mail_template)
    
    @event.should_not be_valid
    @event.should have(1).errors_on(:bounce_address)
  end
  
  %w(abc abc-def abc-123-foo).each do |valid_slug|
    it "accepts #{valid_slug} as slug" do
      @event.slug = valid_slug
      @event.should be_valid
    end
  end
  
  ["fooååå", "foo bar", "flum_hamster"].each do |invalid_slug|
    it "does not accept #{invalid_slug} as slug" do
      @event.slug = invalid_slug
      @event.should_not be_valid
    end
  end
end
