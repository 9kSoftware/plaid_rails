$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "plaid_rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "plaid_rails"
  s.version     = PlaidRails::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of PlaidRails."
  s.description = "TODO: Description of PlaidRails."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.14.1"

  s.add_development_dependency "sqlite3"
end
