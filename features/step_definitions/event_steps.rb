Given /^an event "([^\"]*)"$/ do |arg1|
  Factory(:event)
end

#Given /^a guest to "([^\"]*)" called "([^\"]*)"$/ do |event_name, name|
#  event = Event.find_by_name(event_name)
#  reply = Factory(:reply, :name => name)
#  event.replies << reply
#end

Given /^a guest to "([^\"]*)" called "([^\"]*)"$/ do |event_name, name, table|
  event = Event.find_by_name(event_name)
  
  reply = Factory(:reply, :name => name)
  
  table.hashes.each do |field|
    reply.send("#{field['Name']}=", field['Value'])
  end
  event.replies  << reply
end
  
