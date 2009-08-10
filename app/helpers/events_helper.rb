module EventsHelper
  def food_preferences(reply)
    reply.food_preferences.map(&:name).join(", ") 
  end
  
  def state(reply)
    case reply.aasm_current_state
    when :expired
      "Expired (No payment)"
    when :paid
      "Paid (#{reply.paid_at.strftime("%Y-%m-%d")})"
    when :new
      "Unpaid"
    end
    
  end
end
