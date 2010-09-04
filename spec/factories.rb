Factory.define(:event) do |e|
  e.name "My event"
  e.date DateTime.new(2011, 9, 9, 9, 9)
  e.deadline DateTime.new(2011, 8, 8, 8, 8)
  e.template 'default'
  e.ref_prefix "MyE"
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
