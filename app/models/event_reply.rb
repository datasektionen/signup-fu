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
  
  def cancelled?
    false
    
  end
  
  #state_machine()
  #
  #
  #include AASM
  #
  #aasm_initial_state :new
  #
  #aasm_state :new
  #aasm_state :paid
  #aasm_state :expired
  #aasm_state :cancelled
  #aasm_state :reminded
  #aasm_state :attending
  #
  #aasm_event :pay do
  #  transitions :to => :paid, :from => [:new], :on_transition => :on_paid
  #end
  #
  #aasm_event :expire do
  #  transitions :to => :expired, :from => [:reminded], :on_transition => :on_expire
  #end
  #
  #aasm_event :remind do
  #  transitions :to => :reminded, :from => [:new], :on_transition => :on_remind
  #end
  #
  #aasm_event :cancel do
  #  transitions :to => :cancelled, :from => [:new]
  #end
  #
  #aasm_event :attending do
  #  transitions :to => :attending, :from => [:new, :paid, :reminded]
  #end
  
  belongs_to :event
  belongs_to :ticket_type
  
  has_and_belongs_to_many :food_preferences
  validates_presence_of :event, :name, :email, :ticket_type, :message => 'is required'
  
  named_scope :ascend_by_name, :order => 'name ASC'
  #named_scope :not_cancelled, :conditions => ["aasm_state != 'cancelled'"]
  named_scope :not_cancelled
  
  def self.pay(ids)
    now = Time.now
    EventReply.find(ids).each do |reply|
      reply.pay!
    end
  end
  
  def self.expire_old_unpaid_replies
    all(:include => [:event]).each do |reply|
      event = reply.event
      next unless event.expire_unpaid?
      if reply.should_be_expired?
        reply.expire
      end
    end
  end
  
  def self.remind_old_unpaid_replies
    all(:include => [:event]).each do |reply|
      event = reply.event
      next unless event.expire_unpaid?
      if reply.should_be_reminded?
        reply.remind
      end
    end
  end
  
  def should_be_expired?
    #if !reply.paid? && Time.now > (reply.created_at + event.payment_time.days)
    reminded? &&
      !paid? &&
      Time.now > (created_at + event.payment_time.days) &&
      Time.now > (reminded_at + event.expire_time_from_reminder.days)
  end
  
  def should_be_reminded?
    new? &&
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
      EventMailer.deliver_payment_registered(self)
    end
  end
  
  def on_expire
    if event.send_mail_for?(:ticket_expired)
      EventMailer.deliver_reply_expired_notification(self)
    end
  end
  
  def on_remind
    update_attribute(:reminded_at, Time.now)
    EventMailer.deliver_ticket_expire_reminder(self)
  end
end
