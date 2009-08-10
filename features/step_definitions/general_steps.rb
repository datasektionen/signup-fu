Given /^food preference "([^\"]*)"$/ do |name|
  Factory(:food_preference, :name => name)
end
