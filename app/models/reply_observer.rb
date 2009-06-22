class ReplyObserver < ActiveRecord::Observer
  observe :event_reply
  
  def after_create(reply)
    if reply.event.send_mail_for?(:signup_confirmation)
      EventMailer.deliver_signup_confirmation(reply)
    end
    
  end
  
  def after_save(reply)
    if reply.event.send_mail_for?(:payment_registered) &&
        reply.changes["paid_at"].present? && reply.changes["paid_at"].last != nil
      EventMailer.deliver_payment_registered(reply)
    end
  end
end
