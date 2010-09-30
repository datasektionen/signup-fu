Given /^I am logged in as an admin$/ do
  visit new_user_session_path
  Factory(:admin)
  fill_in "Email", :with => 'admin@example.org'
  fill_in 'Password', :with => 'kakakaka'
  click_button "Sign in"
end


When /^I log in as an admin$/ do
  Given("I am logged in as an admin")
end

When "I sign out" do
  visit destroy_user_session_path
end
