module EventsHelper
  def food_preferences(reply)
    reply.food_preferences.map(&:name).join(", ") 
  end
end
