FactoryGirl.define do
  factory :account, :class => 'PlaidRails::Account' do
    access_token "test_wells"
    plaid_type "wells"
    name "Wells Fargo Credit Card"
    plaid_id "nban4wnPKEtnmEpaKzbYFYQvA7D7pnCaeDBMy"
    owner_type "User"
    owner_id 1
    bank_name "Wells Fargo"
    number 1234
  end

end
