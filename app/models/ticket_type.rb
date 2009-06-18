class TicketType < ActiveRecord::Base
  belongs_to :event
  
  validates_uniqueness_of :name, :scope => :event_id
  
  validates_numericality_of :price, :only_integer => true, :greater_than => 0
end
