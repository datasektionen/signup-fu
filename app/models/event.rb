class Event < ActiveRecord::Base
  has_many :replies, :class_name => 'EventReply', :foreign_key => 'event_id'
  
  has_many :mail_templates do
    def by_name(name)
      puts proxy_target.inspect
      find(:first, :conditions => {:name => name.to_s})
    end
  end
  
  accepts_nested_attributes_for :mail_templates
  
  def full?
    max_guests != 0 && replies.count >= max_guests
  end
  
  def send_mail_for?(name)
    mail_templates.by_name(name).present?
  end
end
