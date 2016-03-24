class AddTransactionsStartDateToAccounts < ActiveRecord::Migration
  def change
    add_column :plaid_rails_accounts, :transactions_start_date, :date
  end
end
