class Event < ActiveRecord::Base
  
  validate :check_correct_mail_templates
  
  has_many :replies, :class_name => 'EventReply', :foreign_key => 'event_id'
  
  has_many :ticket_types
  
  has_many :mail_templates do
    def by_name(name)
      find(:first, :conditions => {:name => name.to_s})
    end
  end
  
  accepts_nested_attributes_for :ticket_types, :reject_if => lambda { |attrs| attrs.values.all?(&:blank?) }
  accepts_nested_attributes_for :mail_templates, :reject_if => lambda { |attrs| attrs.reject { |key, value| key == "name" }.values.all?(&:blank?) }
  
  def full?
    max_guests != 0 && replies.count >= max_guests
  end
  
  def expire_unpaid?
    payment_time.present? && send_mail_for?(:ticket_expired)
  end
  
  def send_mail_for?(name)
    mail_templates.by_name(name).present?
  end
  
  private
  def check_correct_mail_templates
    if mail_templates.map(&:name).include?("ticket_expiry") && !mail_templates.map(&:name).include?("ticket_expire_reminder")
      errors.add_to_base("You can't have ticket_expiry without ticket_expire_reminder")
    end
    
    if !mail_templates.map(&:name).include?("ticket_expiry") && mail_templates.map(&:name).include?("ticket_expire_reminder")
      errors.add_to_base("You can't have ticket_expire_reminder without ticket_expiry")
    end
    
  end
end
