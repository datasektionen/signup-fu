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

Then /^"([^\"]*)" in "([^\"]*)" should have text "([^\"]*)"$/ do |field, context, value|
  within("##{context}") do
    field_labeled(field).value.should == value
  end
end

When /^I take a snapshot$/ do
  save_and_open_page
end

Then /^I should see a checkbox "([^\"]*)"$/ do |label|
  field = find_field(label)
  field['type'].should == 'checkbox'
end

Then /^I should not be on (.+)$/ do |page_name|
  URI.parse(current_url).path.should_not == path_to(page_name)
end
