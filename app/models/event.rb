# encoding: utf-8
class Event < ActiveRecord::Base
  
  validate :check_correct_mail_templates
  validate :validate_ticket_expiry_attributes
  validates_presence_of :ticket_types
  validates_presence_of :template
  validates_presence_of :date
  validates_presence_of :deadline
  validates_presence_of :name
  validates_presence_of :slug
  
  validate :validate_event_date_and_deadline
  validate :presence_of_bounce_address_when_sending_mails
  validates_format_of :slug, :with => /^[a-z][a-z\d\-]*$/
  
  has_many :replies
  has_many :custom_fields
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  has_many :ticket_types
  has_many :mail_templates do
    def by_name(name, options = {})
      template = where(:name => name.to_s).first
      
      if options[:build_new] && template.nil?
        template = new(:name => name.to_s)
      end
      template
    end
  end

  accepts_nested_attributes_for :custom_fields, :reject_if => lambda { |attrs| attrs.values.all?(&:blank?) }
  accepts_nested_attributes_for :mail_templates, :reject_if => lambda { |attrs| attrs.values.all?(&:blank?) || attrs['enable'] != "1" }
  accepts_nested_attributes_for :ticket_types, :reject_if => lambda { |attrs| attrs.values.all?(&:blank?) }
  
  def self.templates
    [
      ['Default', 'default'],
      ['DKM', 'dkm'],
      ['Plums', 'plums'],
      ['Vårbalen', 'varbalen']
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
  
  def has_terms?
    !terms.blank?
  end
  
  def has_payment_reference?
    !ref_prefix.blank?
  end
  
  def ticket_types_for_new_form
    while self.ticket_types.size < 3
      ticket_types.build
    end
    ticket_types
  end
  
  def custom_fields_for_new_form
    while self.custom_fields.size < 3
      custom_fields.build
    end
    custom_fields
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
end
