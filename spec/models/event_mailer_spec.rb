require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe EventMailer do
  
  describe "signup confirmation" do
    before do
      @template_proxy = mock("template proxy")
      @template_proxy.stub!(:by_name).with(:signup_confirmation).and_return(mock_model(MailTemplate, 
        :render_body => "body",
        :render_subject => "subject"
      ))
      
      
      @event = mock_model(Event,
        :email_body => 'Welcome to #EVENT_NAME#, #REPLY_NAME#!',
        :email_subject => "Thanks #REPLY_NAME#",
        :name => 'My event',
        :mail_templates => @template_proxy
      )
      
      
      @reply = mock_model(EventReply,
        :event => @event,
        :name => "Kalle",
        :email => "kalle@example.org"
      )
      
      @email = EventMailer.create_signup_confirmation(@reply)
    end
    
    it "should get the confirmation template" do
      @template_proxy.should_receive(:by_name).with(:signup_confirmation)
      EventMailer.create_signup_confirmation(@reply)
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
end
