class ReplyObserver < ActiveRecord::Observer
  observe :event_reply
  
  def after_create(reply)
    EventMailer.deliver_signup_confirmation(reply)
  end
end
