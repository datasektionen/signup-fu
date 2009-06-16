Then /^the flash should contain "([^\"]*)"$/ do |text|
  response.should have_selector("#flash") do |node|
    node.should contain(text)
  end
end
