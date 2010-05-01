# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key    => '_radio_session',
  :secret => '055f7fb5a6930797d2e1eb2a75395fef012ebc86dcb10043818f375ff6599ec1e811d213b9d0f593ad31574e92c42f7866d46d52b606640eb3ad304b79160e60'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
