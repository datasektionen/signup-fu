class EventReply < ActiveRecord::Base
  
  attr_accessor :send_signup_confirmation
  
  
  state_machine(:payment_state, :initial => :new) do
    state :new
    state :reminded
    state :paid
    state :expired
    
    before_transition :on => :pay, :do => :on_paid
    before_transition :on => :expire, :do => :on_expire
    before_transition :on => :remind, :do => :on_remind
    
    event :pay do
      transition :new => :paid, :reminded => :paid
    end
    
    event :remind do
      transition :new => :reminded
    end
    
    event :expire do
      transition :reminded => :expired
    end
  end
  
  state_machine(:guest_state, :initial => :unknown) do
    state :unknown
    state :attending
    state :cancelled
    
    event :cancel do
      transition :unknown => :cancelled
    end
    
    event :attending do
      transition :unknown => :attending
    end
  end
  
  belongs_to :event
  belongs_to :ticket_type
  
  has_and_belongs_to_many :food_preferences
  validates_presence_of :event, :name, :email, :ticket_type, :message => 'is required'
  validates_acceptance_of :terms, :accept => "1", :message => "måste accepteras"
  validate :correct_pid_format, :if => lambda { |reply| reply.event.present? && reply.event.require_pid? }
  
  before_validation :format_pid
  
  named_scope :ascend_by_name, :order => 'name ASC'
  named_scope :not_cancelled, :conditions => ["guest_state != 'cancelled' AND payment_state != 'expired'"]
  named_scope :not_attending, :conditions => ["guest_state != 'cancelled' AND guest_state != 'attending'"]
  named_scope :paid, :conditions => ["payment_state = 'paid'"]
  
  def self.pay(ids)
    now = Time.now
    EventReply.find(ids).each do |reply|
      reply.pay!
    end
  end
  
  def payment_reference
    return "" unless event.has_payment_reference?
    
    "#{event.ref_prefix}-#{self.id}"
  end
  
  def should_be_expired?
    #puts reminded?
    #puts paid?
    #puts Time.now > (created_at + event.payment_time.days) 
    #puts Time.now > (reminded_at + event.expire_time_from_reminder.days)
    reminded? &&
      !paid? &&
      !cancelled? && 
      Time.now > (created_at + event.payment_time.days) &&
      Time.now > (reminded_at + event.expire_time_from_reminder.days)
  end
  
  def should_be_reminded?
    #puts new?
    #puts Time.now > (created_at + event.payment_time.days)
    (new? && unknown?) &&
      Time.now > (created_at + event.payment_time.days)
  end
  
  def paid?
    paid_at.present?
  end
  
  def send_signup_confirmation=(boolish)
    if [true, "true", "1"].include?(boolish)
      @send_signup_confirmation = true
    else
      @send_signup_confirmation = false
    end
  end
  
  def send_signup_confirmation
    # Default om den inte är satt är att skicka!
    @send_signup_confirmation.nil? || @send_signup_confirmation
  end
  
  def on_paid
    update_attribute(:paid_at, Time.now)
    
    if event.send_mail_for?(:payment_registered)
      EventMailer.send_later(:deliver_payment_registered, self)
    end
  end
  
  def on_expire
    if event.send_mail_for?(:ticket_expired)
      EventMailer.send_later(:deliver_reply_expired_notification, self)
    end
  end
  
  def on_remind
    update_attribute(:reminded_at, Time.now)
    EventMailer.send_later(:deliver_ticket_expire_reminder, self)
  end
  
  def format_pid
    return if self.pid.nil?
    
    pid = self.pid.sub("-", "")
    if pid.length == 10
      self.pid = "#{pid[0..5]}-#{pid[6..9]}"
    elsif pid.length == 12
      self.pid = "#{pid[2..7]}-#{pid[8..11]}"
    end
  end
  
  def correct_pid_format
    if pid !~ /\d{6}-\d{4}/
      errors.add(:pid, "måste anges på korrekt form (YYMMDD-XXXX)")
    end
  end
end
