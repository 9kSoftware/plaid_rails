class CreatePlaidRailsAccounts < ActiveRecord::Migration
  def change
    create_table :plaid_rails_accounts do |t|
      t.string :access_token
      t.string :token
      t.string :plaid_type
      t.string :name
      t.string :bank_name
      t.integer :number
      t.string :plaid_id
      t.string :owner_type
      t.integer :owner_id
      t.datetime :last_sync
      t.decimal :current_balance, :precision => 10, :scale => 2
      t.decimal :available_balance, :precision => 10, :scale => 2
      t.string :error

      t.timestamps
    end
    add_index :plaid_rails_accounts, :access_token
    add_index :plaid_rails_accounts, :owner_id
    add_index :plaid_rails_accounts, :plaid_id
  end
end
