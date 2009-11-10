class ChangeStateColumnsOnEventReplies < ActiveRecord::Migration
  def self.up
    
    aasm_states = EventReply.all.to_a.inject({}) do |hash, reply|
      hash[reply.id] = reply.aasm_state
      hash
    end
    
    change_table :event_replies do |t|
      t.remove :aasm_state
      t.string :payment_state
      t.string :guest_state
    end
    
    EventReply.reset_column_information 
    
    EventReply.all.each do |reply|
      (puts "invalid event: #{reply.event_id}" && next) if reply.event.nil?
      
      aasm_state = aasm_states[reply.id]
      if aasm_state == "cancelled"
        reply.payment_state = "new"
        reply.guest_state = "cancelled"
      elsif aasm_state == "new"
        reply.payment_state = "new"
        reply.guest_state = "new"
      else
        puts "UNKNOWN STATE: #{aasm_state}. ID: #{reply.id}"
        next
      end
      reply.save!
    end
  end

  def self.down
  end
end
