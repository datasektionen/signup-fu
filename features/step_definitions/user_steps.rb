Given /^I am logged in as an admin$/ do
  visit new_user_session_path
  Factory(:admin)
  fill_in "Email", :with => 'admin@example.org'
  fill_in 'Password', :with => 'kakakaka'
  click_button "Sign in"
end

Given "I am logged in as dkm" do
  if User.find_by_email("dkm@d.kth.se").nil?
    Factory(:dkm)
  end
  visit new_user_session_path
  fill_in "Email", :with => 'dkm@d.kth.se'
  fill_in 'Password', :with => 'osthyvel'
  click_button "Sign in"
end

When /^I log in as dkm$/ do
  Given("I am logged in as dkm")
end


When /^I log in as an admin$/ do
  Given("I am logged in as an admin")
end

When "I sign out" do
  visit destroy_user_session_path
end
