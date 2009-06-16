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

Given /^an event "([^\"]*)"$/ do |name|
  Given %Q{an event "#{name}" with fields:}, Cucumber::Ast::Table.new([])
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
  
