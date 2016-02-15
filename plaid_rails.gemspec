$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "plaid_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "plaid_rails"
  s.version     = PlaidRails::VERSION
  s.authors     = ["Curt Wilhelm"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of PlaidRails."
  s.description = "TODO: Description of PlaidRails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1"
  s.add_dependency "jquery-rails"
  s.add_dependency "plaid"
  
  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'shoulda-matchers'
  
  s.test_files = Dir["spec/**/*"]
end
