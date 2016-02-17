module PlaidRails
  class CreateAccountService
  
    # creates a new plaid_rails_account for each account the user has selected
    def self.call(account_params)
      account_params["account_ids"].each  do |id|
        # set Plaid::User
        user = Plaid.set_user(account_params["access_token"],['auth'])
        #find the account by account_id 
        account = user.accounts.select{|a| a.id==id}.first
        
        PlaidRails::Account.create!(
          access_token: account_params["access_token"], 
          plaid_type: account_params["type"],
          name: account.name,
          bank_name: account.meta["name"],
          number: account.meta["number"],
          owner_id: account_params["owner_id"],
          owner_type: account_params["owner_type"],
          plaid_id: id
        ) unless PlaidRails::Account.exists?(plaid_id: id)
      end
        
      PlaidRails::Account.where(owner_id: account_params["owner_id"], 
        owner_type: account_params["owner_type"])
    end
  end
end