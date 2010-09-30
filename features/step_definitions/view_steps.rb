Then /^the notice flash should contain "([^\"]*)"$/ do |text|
  return if text.blank?
  page.should have_css("#flash_notice") do |node|
    node.should contain(text)
  end
end

Then /^the error flash should contain "([^\"]*)"$/ do |text|
  return if text.blank?
  page.should have_css("#flash_error") do |node|
    node.should contain(text)
  end
end

Then /^I should see the tag "([^\"]*)"$/ do |selector|
  page.should have_css(selector)
end

Then /^I should not see the tag "([^\"]*)"$/ do |selector|
  page.should_not have_css(selector)
end

