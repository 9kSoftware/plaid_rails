FactoryGirl.define do
  factory :account, :class => 'PlaidRails::Account' do
    access_token "MyString"
    plaid_type "MyString"
    name "MyString"
    plaid_id "MyString"
    owner_type "User"
    owner_id 1
  end

end
