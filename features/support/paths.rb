module NavigationHelpers
  def path_to(page_name)
    case page_name
    
    when /the homepage/
      root_path
      
    when /the events page/
      events_path
      
    when /the new event page/
      new_event_path
      
    when /the new reply page for "([^\"]*)"/
      event = Event.find_by_name($1)
      new_event_event_reply_path(event)
    
    when /the event page for "([^\"]*)"/
      event = Event.find_by_name($1)
      event_path(event)
      
    when /the economy page for "([^\"]*)"/
      event = Event.find_by_name($1)
      economy_event_event_replies_path(event)
      
    when /the guest list page for "([^\"]*)"/
      event = Event.find_by_name($1)
      event_event_replies_path(event)

    when /the login page/
      new_user_session_path
    
    when /the event login page for "([^\"]*)"/
      event = Event.find_by_name($1)
      new_event_event_session_path(event)
    
    # Add more page name => path mappings here
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in features/support/paths.rb"
    end
  end
end

World(NavigationHelpers)

