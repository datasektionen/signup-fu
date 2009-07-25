class ReplyObserver < ActiveRecord::Observer
  observe :event_reply
  
  def after_create(reply)
    if reply.send_signup_confirmation && reply.event.send_mail_for?(:signup_confirmation)
      EventMailer.deliver_signup_confirmation(reply)
    end
    
  end
end
