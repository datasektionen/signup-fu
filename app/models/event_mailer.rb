class EventMailer < ActionMailer::Base
  
  def signup_confirmation(reply)
    event = reply.event
    recipients reply.email
    from "no-reply@signupfu.com"
    subject "You have been signed up to #{event.name}"
    body :reply => reply, :event => event
  end
end
