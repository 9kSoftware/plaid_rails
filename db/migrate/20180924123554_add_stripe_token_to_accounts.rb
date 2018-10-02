class AddStripeTokenToAccounts < ActiveRecord::Migration
  def change
    add_column :plaid_rails_accounts, :stripe_token, :string
  end
end
