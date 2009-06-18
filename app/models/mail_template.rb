class MailTemplate < ActiveRecord::Base
  belongs_to :event
  
  def render_body(reply)
    replace_variables(body, reply, reply.event)
  end
  
  def render_subject(reply)
    replace_variables(subject, reply, reply.event)
  end
  
  protected
  def replace_variables(string, reply, event)
    string.gsub!("{{REPLY_NAME}}", reply.name)
    string.gsub!("{{EVENT_NAME}}", event.name)
    string
  end
  
end
