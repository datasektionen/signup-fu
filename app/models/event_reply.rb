class EventReply < ActiveRecord::Base
  belongs_to :event
  belongs_to :ticket_type
  validates_presence_of :event, :name, :email, :ticket_type, :message => 'is required'
end
