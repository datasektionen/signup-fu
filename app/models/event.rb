class Event < ActiveRecord::Base
  
  validate :check_correct_mail_templates
  validate :validate_ticket_expiry_attributes
  validates_presence_of :ticket_types
  validates_presence_of :template
  validates_presence_of :date
  validates_presence_of :deadline
  
  validates_uniqueness_of :auth_name
  before_validation_on_create :set_auth_name
  
  validate :validate_event_date_and_deadline
  validate :presence_of_bounce_address_when_sending_mails
  
  
  has_many :replies, :class_name => 'EventReply', :foreign_key => 'event_id'
  
  has_many :ticket_types
  
  has_many :mail_templates do
    def by_name(name)
      find(:first, :conditions => {:name => name.to_s})
    end
  end
  
  acts_as_authentic do |config|
    config.login_field = "auth_name"
    config.merge_validates_length_of_login_field_options({:within => 3..128})
  end
  
  accepts_nested_attributes_for :ticket_types, :reject_if => lambda { |attrs| attrs.values.all?(&:blank?) }
  
  def self.templates
    [
      ['Default', 'default'],
      ['DKM', 'dkm']
    ]
  end
  def full?
    max_guests != 0 && replies.not_cancelled.count >= max_guests
  end
  
  def expire_unpaid?
    payment_time.present? && send_mail_for?(:ticket_expired)
  end
  
  def send_mail_for?(name)
    mail_templates.by_name(name).present?
  end
  
  def mail_templates_attributes=(mail_templates_params)
    mail_templates_params.each_pair do |template_name, template_attributes|
      if template_attributes.delete(:enable) == "1"
        mail_templates << MailTemplate.new(template_attributes)
      end
    end
  end
  
  def has_terms?
    !terms.blank?
  end
  
  def has_payment_reference?
    !ref_prefix.blank?
  end
  
  private
  def check_correct_mail_templates
    if mail_templates.map(&:name).include?("ticket_expired") && !mail_templates.map(&:name).include?("ticket_expire_reminder")
      errors.add_to_base("You can't have ticket_expiry without ticket_expire_reminder")
    end
    
    if !mail_templates.map(&:name).include?("ticket_expired") && mail_templates.map(&:name).include?("ticket_expire_reminder")
      errors.add_to_base("You can't have ticket_expire_reminder without ticket_expiry")
    end
  end
  
  def validate_ticket_expiry_attributes
    if mail_templates.map(&:name).include?("ticket_expired") && mail_templates.map(&:name).include?("ticket_expire_reminder")
      if payment_time.blank?
        errors.add(:payment_time, 'must be present')
      end
      
      if expire_time_from_reminder.blank?
        errors.add(:expire_time_from_reminder, 'must be present')
      end
    end
  end
  
  def validate_event_date_and_deadline
    return if deadline.nil? || date.nil?
    if deadline > date
      errors.add_to_base("Can't have deadline after event date")
    end
  end
  
  def presence_of_bounce_address_when_sending_mails
    if mail_templates.size > 0 && self.bounce_address.blank?
      errors.add(:bounce_address, "must be specified if sending mails")
    end
  end
  
  def set_auth_name
    self.auth_name = Authlogic::Random.hex_token
  end
end
