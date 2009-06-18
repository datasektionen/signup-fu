class EventReply < ActiveRecord::Base
  belongs_to :event
  belongs_to :event_price
  validates_presence_of :event, :name, :email, :event_price, :message => 'is required'
end
