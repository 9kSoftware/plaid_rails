FactoryGirl.define do
  factory :webhook, :class => 'PlaidRails::Webhook' do
    code 0
    message "hello"
    access_token "123abc"
    
  end

end
