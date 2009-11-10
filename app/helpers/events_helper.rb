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
    when :cancelled
      "Cancelled"
    when :attending
      "Attending"
    else
      "Unknown state"
    end
    
  end
end
