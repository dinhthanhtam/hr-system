# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
HrSystem::Application.initialize!

# Config default_url
Rails.configuration.action_mailer.default_url_options = { :host => Settings.host }