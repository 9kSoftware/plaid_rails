require 'spec_helper'
module PlaidRails
  describe CreateAccountService do
  
    let(:user){Plaid.set_user('test_wells', ['auth'])}
  
    let(:account_params){{
          "account_ids"=> user.accounts.map{|a| a.id},
          "access_token"=> 'test_wells',
          "type"=> 'wells',
          "name"=> 'Wells Fargo',
          "owner_id"=> 1,
          "owner_type"=> "User"
    }
    }
  
    it "can call CreateAccountService" do
      accounts =  PlaidRails::CreateAccountService.call(account_params)
      expect(accounts.size).to eq 4
    end
  
  end
end