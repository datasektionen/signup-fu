class Reply < ActiveRecord::Base
  
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
  
  has_many :custom_field_values
  accepts_nested_attributes_for :custom_field_values
  
  
  has_and_belongs_to_many :food_preferences
  validates_presence_of :event, :name, :email, :ticket_type, :message => 'is required'
  validates_acceptance_of :terms, :accept => "1", :message => "måste accepteras"
  validate :correct_pid_format, :if => lambda { |reply| reply.event.present? && reply.event.require_pid? }
  
  before_validation :format_pid
  
  scope :ascend_by_name, order(:name.asc)
  scope :not_cancelled, where(:guest_state.ne => 'cancelled', :payment_state.ne => 'expired')
  scope :not_attending, where(:guest_state.ne => 'cancelled', :guest_state.ne => 'attending')
  scope :paid, where(:payment_state => 'paid')
  scope :unpaid, where(:payment_state => 'new')
  scope :reminded, where(:payment_state => 'reminded')
  
  def self.pay(ids)
    now = Time.now
    Reply.find(ids).each do |reply|
      reply.pay!
    end
  end
  
  def payment_reference
    return "" unless event.has_payment_reference?
    
    "#{event.ref_prefix}-#{self.id}"
  end
  
  def should_be_expired?
    reminded? &&
      !paid? &&
      !cancelled? && 
      Time.now > (created_at + event.payment_time.days) &&
      Time.now > (reminded_at + event.expire_time_from_reminder.days)
  end
  
  def should_be_reminded?
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
      EventMailer.payment_registered(self).delay.deliver
    end
  end
  
  def on_expire
    if event.send_mail_for?(:ticket_expired)
      EventMailer.reply_expired_notification(self).delay.deliver
    end
  end
  
  def on_remind
    update_attribute(:reminded_at, Time.now)
    EventMailer.ticket_expire_reminder(self).delay.deliver
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
