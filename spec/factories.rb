Factory.define(:event) do |e|
  e.name "My event"
  e.date DateTime.new(2010, 9, 9, 9, 9)
  e.deadline DateTime.new(2010, 8, 8, 8, 8)
end

Factory.define(:reply, :class => EventReply) do |r|
  r.email "foo@example.org"
end

Factory.define(:mail_template) do |t|
  t.name 'signup_confirmation'
  t.subject 'Thank you'
  t.body 'thank you for signing up to {{EVENT_NAME}}'
end

Factory.define(:ticket_type) do |p|
  p.price 100
  p.name "With alcohol"
end

Factory.define(:food_preference) do |f|
  f.name "Vegan"
end