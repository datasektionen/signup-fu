module EventsHelper
  def food_preferences(reply)
    reply.food_preferences.map(&:name).join(", ") 
  end
  
  def payment_state(reply)
    case reply.payment_state_name
    when :expired
      "Expired (No payment)"
    when :paid
      "Paid (#{reply.paid_at.strftime("%Y-%m-%d")})"
    when :new
      "Unpaid"
    when :reminded
      "Reminded"
    else
      "Unknown state"
    end
    
  end
  
  def guest_state(reply)
    case reply.guest_state_name
    when :cancelled
      "Cancelled"
    when :attending
      "Attending"
    end
  end
end
