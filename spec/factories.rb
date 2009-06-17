Factory.define(:event) do |e|
  e.name "My event"
  e.date DateTime.new(2009, 9, 9, 9, 9)
  e.deadline DateTime.new(2009, 8, 8, 8, 8)
end

Factory.define(:reply, :class => EventReply) do |r|
  r.email "foo@example.org"
end