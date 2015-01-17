# encoding: utf-8
module EventsHelper
  
  def mail_template_checkbox(mail_template)
    check_box_tag("ladida", "1", false, :onclick => "$('#{mail_template}').checked ? $('#{mail_template}_settings').show():$('#{mail_template}_settings').hide()", :id => "#{mail_template}") +
       %Q{<label for="#{mail_template}">} + t(".#{mail_template}") + "</label>"
  end
  
  def next_button
    button_to_function "#{t('.next_step')} »", "next_step()"
  end
  
  def food_preferences(reply)
    reply.food_preferences.map(&:name).join(", ")
  end
  
  def payment_state(reply)
    case reply.payment_state_name
    when :expired
      t('replies.states.payment.expired')
    when :paid
      t('replies.states.payment.paid', :at => reply.paid_at.strftime("%Y-%m-%d"))
    when :new
      t('replies.states.payment.new')
    when :reminded
      #"Reminded (#{reply.reminded_at.strftime("%Y-%m-%d")})"
      t('replies.states.payment.reminded')
    else
      "Unknown state"
    end
  end
  
  def guest_state(reply)
    case reply.guest_state
    when "unknown"
      t('replies.states.guest.new')
    when "cancelled"
      t('replies.states.guest.cancelled')
    when "attending"
      "Attending"
    else
      "Unknown (#{reply.guest_state_name})"
    end
  end
end
