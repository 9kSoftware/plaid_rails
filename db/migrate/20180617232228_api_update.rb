class ApiUpdate < ActiveRecord::Migration
  def change
    add_column :plaid_rails_webhooks, :item_id, :string
    add_column :plaid_rails_webhooks, :webhook_type, :string
    add_column :plaid_rails_webhooks, :webhook_code, :string
    add_column :plaid_rails_webhooks, :error, :string
    add_column :plaid_rails_webhooks, :new_transactions, :integer
    add_column :plaid_rails_webhooks, :removed_transactions, :text
    add_column :plaid_rails_accounts, :item_id, :string
  end
end
