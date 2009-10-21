Then /^"([^\"]*)" should have (\d+) mail with subject "([^\"]*)"$/ do |address, count, subject|
  count = count.to_i
  
  mails = mailbox_for(address).select {|mail| puts mail.subject; mail.subject == subject }
  mails.size.should == count
end
