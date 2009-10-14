class TicketType < ActiveRecord::Base
  belongs_to :event
  
  validates_uniqueness_of :name, :scope => :event_id
  
  validates_numericality_of :price, :only_integer => true, :greater_than_or_equal_to => 0
end
