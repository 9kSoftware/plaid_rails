class CreatePlaidRailsAccounts < ActiveRecord::Migration
  def change
    create_table :plaid_rails_accounts do |t|
      t.string :access_token
      t.string :plaid_type
      t.string :name
      t.string :bank_name
      t.integer :number
      t.string :plaid_id
      t.string :owner_type
      t.integer :owner_id
      t.timestamps
    end
  end
end
