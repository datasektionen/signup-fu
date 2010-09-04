Given /^now is "([^\"]*)"$/ do |time|
  year, month, day = time.split("-")
  new_now = Time.local(year, month, day, 12, 0)
  Timecop.freeze(new_now)
end

Given /^now is (\d+) (\w+) (.+)$/ do |count, unit, tense|
  time = count.to_i.send(unit).send(tense.gsub(" ", "_"))
  Timecop.freeze(time)
end

