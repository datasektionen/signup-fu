Then /^"([^\"]*)" should have (\d+) mail with subject "([^\"]*)"$/ do |address, count, subject|
  count = count.to_i
  
  mails = mailbox_for(address).select {|mail| puts mail.subject; mail.subject == subject }
  mails.size.should == count
end

Then /^I should see the payment reference for the reply from "([^\"]*)" to "([^\"]*)" in the email body$/ do |guest_name, event_name|
  event = Event.find_by_name(event_name)
  reply = event.replies.detect { |r| r.name == guest_name }
  
  reference = "#{event.ref_prefix}-#{reply.id}"
  
  current_email.body.should contain(reference)
end

