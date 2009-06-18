Given /^that now is "([^\"]*)"$/ do |time|
  year, month, day = time.split("-")
  Time.stub!(:now).and_return(Time.local(year, month, day, 12, 0))
end
