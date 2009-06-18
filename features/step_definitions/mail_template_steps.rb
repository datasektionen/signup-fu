Given /^"([^\"]*)" has mail template "([^\"]*)" with fields:$/ do |event_name, template_name, table|
  event = Event.find_by_name(event_name)
  template = event.mail_templates.new(:name => template_name)
  
  table.hashes.each do |field|
    template.send("#{field['Name']}=", field['Value'])
  end
  template.save!
end
