class EventMailer < ActionMailer::Base
  
  def signup_confirmation(reply)
    event = reply.event
    template = event.mail_templates.by_name(:confirmation)
    
    body = template.render_body(reply)
    subject = template.render_subject(reply)
    
    recipients reply.email
    from "no-reply@signupfu.com"
    subject subject
    body body
  end
  
  protected
end
