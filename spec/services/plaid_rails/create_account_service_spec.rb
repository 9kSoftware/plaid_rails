require 'spec_helper'
module PlaidRails
  describe CreateAccountService do
  
    let(:client){Plaid::Client.new(env: PlaidRails.env,
                  client_id: PlaidRails.client_id,
                  secret: PlaidRails.secret,
                  public_key: PlaidRails.public_key)}
    let(:access_token){create_access_token}
  
    let(:account_params){{
          "account_ids"=> client.accounts.get(access_token).accounts.map{|a| a.account_id},
          "access_token"=> access_token,
          "type"=> 'wells',
          "name"=> 'Wells Fargo',
          "owner_id"=> 1,
          "owner_type"=> "User",
          "token"=>'test,wells,connected'
    }
    }
  
    it "can call CreateAccountService" do
      accounts =  PlaidRails::CreateAccountService.call(account_params)
      expect(accounts.size).to eq 5
    end
  
  end
end