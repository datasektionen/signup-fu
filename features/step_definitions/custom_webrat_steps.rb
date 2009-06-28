Then /^I should see "([^\"]*)" in "([^\"]*)"$/ do |text, dom_id|
  response.should match_selector("##{dom_id}") do |node|
    node.should contain(text)
  end
end

When /^I fill in "([^\"]*)" with "([^\"]*)" in "([^\"]*)"$/ do |field, value, context|
  within("##{context}") do
    fill_in(field, :with => value)
  end
end

