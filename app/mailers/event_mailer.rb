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
    bounce_address = reply.event.bounce_address
    
    mail(:to => reply.email, :subject => subject, :reply_to => bounce_address, :from => bounce_address, "Return-Path" => bounce_address) do |format|
      format.text { render :text => body }
    end
  end
end
