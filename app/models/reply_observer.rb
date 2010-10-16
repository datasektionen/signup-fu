class ReplyObserver < ActiveRecord::Observer
  observe :reply
  
  def after_create(reply)
    if reply.send_signup_confirmation && reply.event.send_mail_for?(:signup_confirmation)
      begin
        EventMailer.signup_confirmation(reply).delay.deliver
      rescue Net::SMTPFatalError => e
      rescue Net::SMTPAuthenticationError => e
      end
    end
    
  end
end
