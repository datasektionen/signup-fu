# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_signup_fu_session',
  :secret      => '63df56b2ef0225664d9f1c36737478bf5eb7ce8f576cadf3238d4563057bb5a85813cc93ce38a6d1cf30c5220bd68fb47dd07b716fce01951825196302883b35'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
