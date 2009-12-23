class ExpiryRun
  def initialize(event_id)
    @event_id = event_id
  end
  
  def perform
    event = Event.find(@event_id)
    event.replies(:include => [:event]).each do |reply|
      if reply.should_be_expired?
        reply.expire
      end
    end
    
  end
end