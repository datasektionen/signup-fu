When /^I check the paid checkbox for "([^\"]*)"$/ do |name|
  reply = EventReply.find_by_name(name)
  
  check("reply_#{reply.id}")
end
