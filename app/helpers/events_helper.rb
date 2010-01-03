module EventsHelper
  def food_preferences(reply)
    reply.food_preferences.map(&:name).join(", ") 
  end
  
  def payment_state(reply)
    case reply.payment_state_name
    when :expired
      t('event_replies.states.payment.expired')
    when :paid
      t('event_replies.states.payment.paid', :at => reply.paid_at.strftime("%Y-%m-%d"))
    when :new
      t('event_replies.states.payment.new')
    when :reminded
      #"Reminded (#{reply.reminded_at.strftime("%Y-%m-%d")})"
      t('event_replies.states.payment.reminded')
    else
      "Unknown state"
    end
  end
  
  def guest_state(reply)
    case reply.guest_state_name
    when :unknown
      t('event_replies.states.guest.new')
    when :cancelled
      t('event_replies.states.guest.cancelled')
    when :attending
      "Attending"
    else
      "Unknown (#{reply.guest_state_name})"
    end
  end
end
