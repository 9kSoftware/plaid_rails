module PlaidRails
  class CreateAccountService
  
    # creates a new plaid_rails_account for each account the user has selected
    def self.call(account_params)
      account_params["account_ids"].each  do |id|
        # Create the Plaid Client
        client = Plaid::Client.new(env: PlaidRails.env,
                  client_id: PlaidRails.client_id,
                  secret: PlaidRails.secret,
                  public_key: PlaidRails.public_key)
        #find the account by account_id 
        account = client.accounts.get(account_params["access_token"]).accounts.find{|a| a.account_id==id}
        response =  client.item.get(account_params["access_token"])
        item = response.item
        response = client.institutions.get_by_id(item['institution_id'])
        institution = response.institution
        PlaidRails::Account.create!(
          access_token: account_params["access_token"], 
          plaid_type: item.institution_id,
          name: account.name,
          bank_name: institution.name,
          number: account.mask,
          owner_id: account_params["owner_id"],
          owner_type: account_params["owner_type"],
          available_balance: account.balances.available,
          current_balance: account.balances.current,
          transactions_start_date: account_params["transactions_start_date"],
          plaid_id: id,
          item_id: item.item_id
        ) unless PlaidRails::Account.exists?(plaid_id: id)
      end
      
      PlaidRails::Account.where(owner_id: account_params["owner_id"], 
        owner_type: account_params["owner_type"])
    end
  end
end