class EventReply < ActiveRecord::Base
  belongs_to :event
  validates_presence_of :name, :email, :message => 'is required'
end
