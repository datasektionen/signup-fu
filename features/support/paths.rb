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
      event = find_event($1)
      public_new_reply_path(event.owner.name, event.slug)
      #new_event_reply_path(event)
    
    when /the event page for "([^\"]*)"/
      event = find_event($1)
      event_path(event)
      
    when /the economy page for "([^\"]*)"/
      event = find_event($1)
      economy_event_replies_path(event)
      
    when /the guest list page for "([^\"]*)"/
      event = find_event($1)
      event_replies_path(event)
      
    when /the permit report page for "([^\"]*)"/
      event = find_event($1)
      permit_event_replies_path(event)
    

    when /the login page/
      new_user_session_path
    
    # Add more page name => path mappings here
    
    else
      raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
        "Now, go and add a mapping in features/support/paths.rb"
    end
  end
  
  def find_event(name)
    event = Event.find_by_name(name)
    raise "No event found" if event.nil?
    event
  end
end

World(NavigationHelpers)

