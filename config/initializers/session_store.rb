# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_abtt_new_session',
  :secret      => '00c56cc43c702abfea8bd473ca1a552b1143e55680d08f444f4d0db1f13674dd522da6954cfcf0416a5efc61ba8a99e1f529aa1875038571046de463144c4b6c'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
