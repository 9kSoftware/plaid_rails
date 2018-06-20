ENV['RAILS_ENV'] ||= 'test'
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'factory_girl_rails'
require 'shoulda-matchers'
require 'plaid'
require 'webmock/rspec'

WebMock.allow_net_connect!
unless ENV['PLAID_CLIENT_ID']
  $stderr.puts "Missing Plaid Credentials.  Set PLAID_CLIENT_ID,PLAID_SECRET,PLAID_PUBLIC_KEY" 
  exit(1)
end
PlaidRails.configure do |p|
  p.client_id = ENV['PLAID_CLIENT_ID']
  p.secret = ENV['PLAID_SECRET']
  p.public_key = ENV['PLAID_PUBLIC_KEY']
  p.env = :sandbox
  
  # FOR TESTING NOTIFICATIONS
  p.subscribe "transactions.initial" do |event|
    Rails.logger.debug "transactions.initial #{event.inspect}"
  end
  p.subscribe "transactions.new" do |event|
    Rails.logger.debug "transactions.new #{event.inspect}"
  end
  p.subscribe "transactions.interval" do |event|
    Rails.logger.debug "transactions.interval #{event.inspect}"
  end
  p.subscribe "transactions.removed" do |event|
    Rails.logger.debug "transactions.removed #{event.inspect}"
  end
  p.subscribe "webhook.updated" do |event|
    Rails.logger.debug "webhook.updated #{event.inspect}"
  end
  p.subscribe "plaid.error" do |event|
    Rails.logger.debug "plaid.error #{event.inspect}"
  end
end

Rails.backtrace_cleaner.remove_silencers!
# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!
RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.infer_spec_type_from_file_location!
  config.include FactoryGirl::Syntax::Methods
  config.include TokenHelper
end