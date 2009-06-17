class Event < ActiveRecord::Base
  has_many :replies, :class_name => 'EventReply', :foreign_key => 'event_id'
  
  def full?
    max_guests != 0 && replies.count >= max_guests
  end
end
