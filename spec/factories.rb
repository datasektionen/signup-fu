Factory.define(:event) do |e|
  e.date DateTime.new(2011, 9, 9, 9, 9)
  e.deadline DateTime.new(2011, 8, 8, 8, 8)
  e.template 'default'
  e.name "MY FUCKING EVENT OF DEATH"
end

Factory.define(:my_event, :parent => :event) do |f|
  f.name "My event"
  f.ref_prefix "MyE"
  f.owner { |a| User.find_by_email("myuser@example.org") || a.association(:my_user) }
  f.slug "my-event"
end

Factory.define(:plums, :parent => :event) do |f|
  f.name "Plums"
  f.ref_prefix "PLUMS"
  f.owner { |a| User.find_by_email("dkm@d.kth.se") || a.association(:dkm) }
  f.slug "plums"
end

Factory.define(:d_dagsgasque, :parent => :event) do |f|
  f.name "D-dagsgasque"
  f.owner { |a| User.find_by_email("naringsliv@d.kth.se") || a.association(:nlg) }
  f.slug "ddagen"
end

Factory.define(:reply) do |r|
  r.email "foo@example.org"
  r.name "Kalle Testson"
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

Factory.define(:user) do |f|
  
end

Factory.define(:admin, :parent => :user) do |f|
  f.email "admin@example.org"
  f.password "kakakaka"
  f.admin true
  f.name "admin"
end

Factory.define(:dkm, :parent => :user) do |f|
  f.email "dkm@d.kth.se"
  f.password "osthyvel"
  f.admin false
  f.name "dkm"
end

Factory.define(:nlg, :parent => :user) do |f|
  f.email 'naringsliv@d.kth.se'
  f.password 'pastaslev'
  f.admin false
  f.name "naringsliv"
end

Factory.define(:my_user, :parent => :user) do |f|
  f.email "myuser@example.org"
  f.password "kookies"
  f.admin false
  f.name "my"
end

#Factory.define(:admin, :class => User) do |f|
#  salt = Authlogic::Random.hex_token
#  f.login 'admin'
#  f.email "admin@example.org"
#  f.password_salt salt
#  #f.crypted_password Authlogic::CryptoProviders::Sha512.encrypt("benrocks" + salt)
#  f.password 'kaka15'
#  f.password_confirmation 'kaka15'
#  f.persistence_token Authlogic::Random.hex_token 
#  f.single_access_token Authlogic::Random.friendly_token
#  f.perishable_token Authlogic::Random.friendly_token
#  f.admin true
#end
