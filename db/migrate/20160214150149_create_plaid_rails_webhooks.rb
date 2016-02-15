class CreatePlaidRailsWebhooks < ActiveRecord::Migration
  def change
    create_table :plaid_rails_webhooks do |t|
      t.integer :code 
      t.string :message
      t.string :access_token
      t.text :params

      t.timestamps
    end
  end
end
