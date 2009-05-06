class Event < ActiveRecord::Base
  has_many :replies, :class_name => 'EventReply', :foreign_key => 'event_id'
end
