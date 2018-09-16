# Plaid for Rails

[![Build Status](https://travis-ci.org/9kSoftware/plaid_rails.svg?branch=master)](https://travis-ci.org/9kSoftware/plaid_rails)

This gem is a Rails Engine to provide an interface to [Plaid](http://plaid.com) using the plaid-ruby api

PlaidRails provides these features:

* Accepts webhooks callbacks from plaid to manage transaction requests or errors
* Configures Plaid Link to easily connect with the banks
* Stores bank details to use within your application

## Installation

Add the gem to your app

```ruby
gem 'plaid_rails'
```

Run the installer
```bash
bundle install
rails g plaid_rails:install
rake db:migrate
```

The plaid_rails:install task does the following:

* add the plaid_rails engine to the config/routes.rb 
config/initializer/plaid.rb
```ruby
mount PlaidRails::Engine => '/plaid', as: :plaid_rails` to the config/routes.rb
```
* Create the initializer config/initializer/plaid.rb.  Be sure to update this with your settings
* Update the app/assets/javascript/application.js with `//= require plaid_rails`


### Views

Add a button and javascript to your view to use [Link](https://plaid.com/docs/#link) with Plaid.

```ruby
<button id="plaidLinkButton" class="small"
     data-client-name="<%= client_name %>"
     data-env="<%= Rails.env.production? ? "production" : "tartan"%>"
     data-key="<%=  PlaidRails.public_key %>"
     data-webhook="<%=  PlaidRails.webhook %>"
     data-longtail="<%=  PlaidRails.longtail %>"
     data-owner-type="<%=  owner.class.name %>"
     data-plaid-rails-path='/plaid/authenticate'
     data-product='transactions'
     data-owner-id="<%=  owner.id %>">Link your Bank Account</button>

<!-- put at bottom of page -->
<%=javascript_include_tag "https://cdn.plaid.com/link/stable/link-initialize.js" %>
```

Overwrite the plaid_rails views with your own views.
* plaid_rails/accounts/create.html - rendered after creating an account
* plaid_rails/accounts/destroy.html - rendered after removing an account
* plaid_rails/accounts/index.html - renders the list of accounts connected
* plaid_rails/accounts/new.html - renders list of available accounts to connect
* plaid_rails/link/authenticate.js.erb - renders after the Plaid.create javascript function is successful

### Webhooks
The plaid webhooks runs subscribers for to process transactions and report errors.  

* transactions.initial - code 0
* transactions.new - code 1
* transactions.interval - code 2
* transactions.removed - code 3
* webhook.updated - code 4
* plaid.error - any other code

Update the PlaidRails.configuration.webhook with  the address of the webhook url.  The route is `plaid/webhook`
i.e. http(s)://my.app.com/plaid/webhooks 

### Testing
To run the tests you need to set the PLAID credentials in environment variables.
```bash
export PLAID_CLIENT_ID='your client_id'
export PLAID_SECRET='your secret'
export PLAID_PUBLIC_KEY='your public_key'
```