Then /^the notice flash should contain "([^\"]*)"$/ do |text|
  return if text.blank?
  response.should have_selector("#flash_notice") do |node|
    node.should contain(text)
  end
end

Then /^the error flash should contain "([^\"]*)"$/ do |text|
  return if text.blank?
  response.should have_selector("#flash_error") do |node|
    node.should contain(text)
  end
end

Then /^I should see the tag "([^\"]*)"$/ do |selector|
  response.should have_selector(selector)
end

Then /^I should not see the tag "([^\"]*)"$/ do |selector|
  response.should_not have_selector(selector)
end

Then /^I should not be redirected$/ do
  response.should_not be_redirect
end

Then /^I should not get an (\d+) status code$/ do |status|
  status = status.to_i
  response.status.to_i.should_not == status
end

Then /^I should get an (\d+) status code$/ do |status|
  status = status.to_i
  response.status.to_i.should == status
end

