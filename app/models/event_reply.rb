class EventReply < ActiveRecord::Base
  belongs_to :event
  belongs_to :ticket_type
  validates_presence_of :event, :name, :email, :ticket_type, :message => 'is required'
  
  def self.set_as_paid(ids)
    now = Time.now
    EventReply.find(ids).each do |reply|
      reply.update_attributes!(:paid_at => now)
    end
  end
  
  def paid?
    paid_at.present?
  end
end
