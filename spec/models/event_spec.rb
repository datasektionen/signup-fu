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
    
    expect(@event).not_to be_valid
  end
  
  it "should not accept ticket_expiry without ticket_expire_reminder" do
    event = Event.new(@valid_params)
    event.mail_templates << MailTemplate.new(:name => 'ticket_expired')
    
    expect(event).not_to be_valid
    expect(event.errors[:base]).to include("You can't have ticket_expiry without ticket_expire_reminder")
    
  end
  
  it "should not accept ticket_expire_reminder without ticket_expiry" do
    event = Event.new(@valid_params)
    event.mail_templates << MailTemplate.new(:name => 'ticket_expire_reminder')
    
    expect(event).not_to be_valid
    expect(event.errors[:base]).to include("You can't have ticket_expire_reminder without ticket_expiry")
  end
  
  it "should require payment time if ticket_expiry" do
    event = Event.new(@valid_params.with(:expire_time_from_reminder => 10))
    event.mail_templates << MailTemplate.new(:name => 'ticket_expired')
    event.mail_templates << MailTemplate.new(:name => 'ticket_expire_reminder')
    
    expect(event).not_to be_valid
    expect(event).to have(1).error_on(:payment_time)
  end
  
  it "should require reminder time if ticket_expiry" do
    event = Event.new(@valid_params.with(:payment_time => 10))
    event.mail_templates << MailTemplate.new(:name => 'ticket_expired')
    event.mail_templates << MailTemplate.new(:name => 'ticket_expire_reminder')
    
    expect(event).not_to be_valid
    expect(event).to have(1).error_on(:expire_time_from_reminder)
  end
  
  it "should not be valid with a expiry and no payment time" do
    event = Event.new(@valid_params.with(:expire_time_from_reminder => 10))
    event.mail_templates << MailTemplate.new(:name => 'ticket_expired')
    event.mail_templates << MailTemplate.new(:name => 'ticket_expire_reminder')
    expect(event).not_to be_valid
    expect(event).to have(1).error_on(:payment_time)
  end
  
  it "should be full if it has more than max_guest guests" do
    event = Event.create!(@valid_params.with(:max_guests => 1))
    event.replies.create!(:name => 'Kalle', :email => 'kalle@example.org', :ticket_type => mock_model(TicketType))
    
    expect(event).to be_full
  end
  
  it "should not be full with max_guests = 1 and one cancelled reply" do
    event = Event.create!(@valid_params.with(:max_guests => 1))
    reply = event.replies.create!(:name => 'Kalle', :email => 'kalle@example.org', :ticket_type => mock_model(TicketType))
    reply.cancel!
    
    expect(event).not_to be_full
    
  end
  
  it "should expire unpaid if it has a template and a payment time" do
    @event = Event.new(@valid_params.with(:payment_time => 10))
    template = Factory(:mail_template, :event => @event, :name => 'ticket_expired')
    
    expect(@event.expire_unpaid?).to be_truthy
  end
  
  it "should not expire unpaid if it has no template" do
    @event = Event.new(@valid_params.with(:payment_time => 10))
    
    expect(@event.expire_unpaid?).to be_falsey
  end
  
  
  it "should expire unpaid if it has no payment time" do
    @event = Event.new(@valid_params.with(:payment_time => nil))
    template = Factory(:mail_template, :event => @event, :name => 'ticket_expired')
    
    expect(@event.expire_unpaid?).to be_falsey
  end
  
  
  it "should check if it has mailtemplate by name" do
    expect(@event.send_mail_for?(:signup_confirmation)).to eql(false)
  end
  
  it "should send_mail_for?(:signup_confirmation) if there are a signup confirmation template" do
    @event.save!
    @event.mail_templates.create!(:name => 'signup_confirmation', :body => 'body', :subject => 'subject')
    expect(@event.send_mail_for?(:signup_confirmation)).to eql(true)
  end
  
  it "should fetch mail templates by name" do
    @event.save!
    confirmation_template = Factory(:mail_template, :event => @event, :name => 'signup_confirmation')
    
    expect(@event.mail_templates.by_name(:signup_confirmation)).to eql(confirmation_template)
  end
  
  it "should have a has_terms?" do
    allow(@event).to receive(:terms).and_return(nil)
    expect(@event.has_terms?).to eql(false)
    
    allow(@event).to receive(:terms).and_return("here be legal stuff")
    expect(@event.has_terms?).to eql(true)
  end
  
  it "should remind replies that should be remindeded...." do
    
    allow(Event).to receive(:find).with(@event.id).and_return(@event)
    
    allow(@event).to receive(:expire_unpaid?).and_return(true)
    
    unpaid_old_reply = mock_model(Reply, :event => @event)
    allow(unpaid_old_reply).to receive(:should_be_reminded?).and_return(true)
    reply2 = mock_model(Reply, :event => @event)
    allow(reply2).to receive(:should_be_reminded?).and_return(false)
    
    allow(@event).to receive(:replies).and_return([unpaid_old_reply, reply2])
    
    expect(unpaid_old_reply).to receive(:remind!)
    
    ReminderRun.new(@event.id).perform
  end
  
  describe "the expiration process" do
    it "should not expire tickets that should not be expired" do
      allow(Event).to receive(:find).with(@event.id).and_return(@event)
      allow(@event).to receive(:expire_unpaid?).and_return(true)
      
      reply_that_shall_not_expire = mock_model(Reply, :event => @event, :should_be_expired? => false)
      reply_that_shall_expire = mock_model(Reply, :event => @event, :should_be_expired? => true)
      allow(@event).to receive(:replies).and_return([reply_that_shall_expire, reply_that_shall_not_expire])
      
      expect(reply_that_shall_not_expire).not_to receive(:expire)
      expect(reply_that_shall_expire).to receive(:expire)
      
      ExpiryRun.new(@event.id).perform
    end
  end
  
  it "must specify an return address if any email template is used" do
    @event.mail_templates << Factory(:mail_template)
    
    expect(@event).not_to be_valid
    expect(@event).to have(1).errors_on(:bounce_address)
  end
  
  %w(abc abc-def abc-123-foo).each do |valid_slug|
    it "accepts #{valid_slug} as slug" do
      @event.slug = valid_slug
      expect(@event).to be_valid
    end
  end
  
  ["fooååå", "foo bar", "flum_hamster"].each do |invalid_slug|
    it "does not accept #{invalid_slug} as slug" do
      @event.slug = invalid_slug
      expect(@event).not_to be_valid
    end
  end
end
