Given /^an event "([^\"]*)" with fields:$/ do |name, table|
  event = Factory(:event, :name => name)

  unless table.raw.empty?
    table.hashes.each do |field|
      case field["Name"]
      when /deadline/
        field['Value'] =~ /(\d)+ days ago/
        deadline = $1.to_i.days.ago
        event.deadline = deadline
        
      else
        event.send("#{field['Name']}=", field['Value'])
      end
    end
  end
  
  event.save!
  
end

Given /^a ticket type "([^\"]*)" for (\d+) on "([^\"]*)"$/ do |ticket_type_name, amount, event_name|
  event = Event.find_by_name(event_name)
  
  event.ticket_types.create!(:name => ticket_type_name, :price => amount)
end


Given /^an event "([^\"]*)"$/ do |name|
  Given %Q{an event "#{name}" with fields:}, Cucumber::Ast::Table.new([])
end

Given /^(\d+) guests signed up to "([^\"]*)"$/ do |count, event_name|
  count = count.to_i
  event = Event.find_by_name(event_name)
  
  ticket_type = event.ticket_types.first
  
  if ticket_type.nil?
    raise "No ticket type for event #{event.name}"
  end
  
  count.times do |i|
    reply = Factory(:reply,
      :name => "Arne #{i} Anka",
      :email => "arne.#{i}@example.org",
      :event => event,
      :ticket_type => ticket_type
    )
    event.replies << reply
  end
  
end



#Given /^a guest to "([^\"]*)" called "([^\"]*)"$/ do |event_name, name|
#  event = Event.find_by_name(event_name)
#  reply = Factory(:reply, :name => name)
#  event.replies << reply
#end

Given /^a guest to "([^\"]*)" called "([^\"]*)"$/ do |event_name, name, table|
  event = Event.find_by_name(event_name)
  
  ticket_type = event.ticket_types.first
  
  if ticket_type.nil?
    raise "No ticket type for event #{event.name}"
  end
  
  reply = Factory(:reply, :ticket_type => ticket_type, :name => name, :event => event)
  
  table.hashes.each do |field|
    case field['Name']
    when /Food Preferences/i
      pref = FoodPreference.find_by_name(field['Value'])
      raise "No such food preference" if pref.nil?
      reply.food_preferences << pref
    else
      reply.send("#{field['Name']}=", field['Value'])
    end
  end
  event.replies  << reply
end
  
Given /^that "([^\"]*)" has a payment time of (\d+) days$/ do |event_name, count|
  event = Event.find_by_name(event_name)
  event.payment_time = count.to_i
  event.save!
end

Given /^that "([^\"]*)" has a expire time from reminder of (\d+) days$/ do |event_name, count|
  event = Event.find_by_name(event_name)
  event.expire_time_from_reminder = count.to_i
  event.save!
end


When /^the ticket expire process is run$/ do
  EventReply.expire_old_unpaid_replies
end

When /^the reminder process is run$/ do
  EventReply.remind_old_unpaid_replies
end


When /^I mark "([^\"]*)" as paid$/ do |reply_name|
  event = Event.first
  
  raise "No event" if event.nil?
  
  When %Q{I go to the economy page for "#{event.name}"}
  
  When "I check the paid checkbox for \"#{reply_name}\""
  
  click_button("Save")
  
  
end

When /^I fill in the following ticket types:$/ do |table|
  table.raw.each_with_index do |ticket, i|
    ticket_name, ticket_price = ticket
    fill_in "Ticket type #{i + 1} name", :with => ticket_name
    fill_in "Ticket type #{i + 1} price", :with => ticket_price
  end
end

Then /^the food preferences summary should show (\d+) (.*)$/ do |count, kind|
  response.body.should match_selector("#food_preferences_summary") do |table|
    table.css("tr").any? { |tr| tr.css("th").first.content == kind && tr.css("td").first.content == count }
  end
end




