# Plaid for Rails

[ ![Codeship Status for cdwilhelm/plaid_rails](https://codeship.com/projects/0ffcd970-b638-0133-0560-5ef9b905983d/status?branch=master)](https://codeship.com/projects/134308)

This gem is a Rails Engine to provide an interface to (Plaid)[http://plaid.com] using the plaid-ruby api

## Installation

Add the gem to your app

```gem 'plaid_rails'```

Run the installer
```bash
bundle install
rails g plaid_rails:install
rake db:migrate```

The plaid_rails:install task will add the plaid_rails engine to the config/routes.rb and create an initializer 
```config/initializer/plaid.rb
mount PlaidRails::Engine => '/plaid', as: :plaid_rails` to the config/routes.rb```

Update the config/initializer/plaid.rb configuration for your application.

### Views

Add a button and javascript to your view to link connect to bank accounts using Plaid.
```ruby
<button id="plaidLinkButton" class="small">Link your Bank Account</button>


<div id="plaid-data"
     data-client-name="<%= client_name %>"
     data-env="<%= Rails.env.production? ? "production" : "tartan"%>"
     data-key="<%=  PlaidRails.public_key %>"
     data-webhook="<%=  PlaidRails.webhook %>"
     data-owner-type="<%=  owner.class.name %>"
     data-owner-id="<%=  owner.id %>">
</div>

<!-- put at bottom of page -->
<%=javascript_include_tag "https://cdn.plaid.com/link/stable/link-initialize.js" %>
<%=javascript_include_tag "plaid_rails/link.js" %>```

Overwrite the plaid_rails views with your own views.
* plaid_rails/accounts/create.html - rendered after creating an account
* plaid_rails/accounts/destroy.html - rendered after removing an account
* plaid_rails/accounts/index.html - renders the list of accounts connected
* plaid_rails/accounts/new.html - renders list of available accounts to connect
* plaid_rails/link/authenticate.js.erb - renders after the Plaid.create javascript function is successful

### Webhooks
The plaid webhooks will process the subscribe to notifiers to run transactions and report errors.  

* transactions.initial - code 0
* transactions.new - code 1
* transactions.interval - code 2
* transactions.removed - code 3
* webhook.updated - code 4
* plaid.error - any other code

Update the PlaidRails.configuration.webhook with  the address of the webhook url.  The route is `plaid_rails/webhook`
i.e. http(s)://my.app.com/plaid_rails/webhooks 