= PlaidRails

[ ![Codeship Status for cdwilhelm/plaid_rails](https://codeship.com/projects/0ffcd970-b638-0133-0560-5ef9b905983d/status?branch=master)](https://codeship.com/projects/134308)

This project rocks and uses MIT-LICENSE.

### Configuration

gem 'plaid_rails'
bundle install
add   `mount PlaidRails::Engine => '/plaid', as: :plaid_rails` to the config/routes.rb

### Webhooks

http(s)://my.app.com/plaid_rails/webhooks