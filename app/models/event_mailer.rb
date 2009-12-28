class EventMailer < ActionMailer::Base
  
  def signup_confirmation(reply)
    event = reply.event
    template = event.mail_templates.by_name(:signup_confirmation)
    
    send_mail_from_template(reply, template)
  end
  
  def payment_registered(reply)
    event = reply.event
    
    template = event.mail_templates.by_name(:payment_registered)
    
    send_mail_from_template(reply, template)
  end
  
  def reply_expired_notification(reply)
    event = reply.event
    
    template = event.mail_templates.by_name(:ticket_expired)
    
    send_mail_from_template(reply, template)
  end
  
  def ticket_expire_reminder(reply)
    event = reply.event
    
    template = event.mail_templates.by_name(:ticket_expire_reminder)
    
    send_mail_from_template(reply, template)
    
  end
  
  protected
  
  def send_mail_from_template(reply, template)
    body = template.render_body(reply)
    subject = template.render_subject(reply)
    
    recipients reply.email
    from "no-reply@h.patrikstenmark.se"
    subject subject
    body body
    reply_to reply.event.bounce_address
    headers "Return-Path" => reply.event.bounce_address
    
  end
end
