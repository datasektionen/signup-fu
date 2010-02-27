require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventMailer do
  before do
    @template_proxy = mock("template proxy")
    
    @event = mock_model(Event,
      :email_body => 'Welcome to #EVENT_NAME#, #REPLY_NAME#!',
      :email_subject => "Thanks #REPLY_NAME#",
      :bounce_address => 'kaka@example.org',
      :name => 'My event',
      :mail_templates => @template_proxy
    )
    
    @reply = mock_model(EventReply,
      :event => @event,
      :name => "Kalle",
      :email => "kalle@example.org"
    )
  end
  
  shared_examples_for "templated email" do
    before do
    end
    
    it "should get subject from template" do
      @email.should have_subject(/subject/)
    end
    
    it "should get body from the template" do
      @email.should have_text(/body/)
    end
    
    it "should send mail to the correct address" do
      @email.should deliver_to("kalle@example.org")
    end
    
    it "should set from mail from settings"
    
  end
  describe "signup confirmation" do
    before do
      
      @template_proxy.stub!(:by_name).with(:signup_confirmation).and_return(mock_model(MailTemplate, 
        :render_body => "body",
        :render_subject => "subject"
      ))
      
      # For shared steps
      @email = EventMailer.create_signup_confirmation(@reply)
    end
    
    it "should get the confirmation template" do
      @template_proxy.should_receive(:by_name).with(:signup_confirmation).and_return(mock_model(MailTemplate, 
        :render_body => "body",
        :render_subject => "subject"
      ))
      EventMailer.create_signup_confirmation(@reply)
    end
    
    it_should_behave_like "templated email"
    
  end
  
  describe "payment registered" do
    before do
      @template_proxy.stub!(:by_name).with(:payment_registered).and_return(mock_model(MailTemplate, 
        :render_body => "body",
        :render_subject => "subject"
      ))
      
      # For shared steps
      @email = EventMailer.create_payment_registered(@reply)
    end
    
    it "should get the correct template" do
      @template_proxy.should_receive(:by_name).with(:payment_registered).and_return(mock_model(MailTemplate, 
        :render_body => "body",
        :render_subject => "subject"
      ))
      EventMailer.create_payment_registered(@reply)
    end
    
    it_should_behave_like "templated email"
  end
  
  describe "expiry notice" do
    before do
      @template_proxy.stub!(:by_name).with(:ticket_expired).and_return(mock_model(MailTemplate, 
        :render_body => "body",
        :render_subject => "subject"
      ))
      
      # For shared steps
      @email = EventMailer.create_reply_expired_notification(@reply)
    end
    
    it_should_behave_like "templated email"
    
  end
  
  describe "reminders" do
    before do
      @template_proxy.stub!(:by_name).with(:ticket_expire_reminder).and_return(mock_model(MailTemplate, 
        :render_body => "body",
        :render_subject => "subject"
      ))
      
      # For shared steps
      @email = EventMailer.create_ticket_expire_reminder(@reply)
    end
    
    it_should_behave_like "templated email"
  end
end
