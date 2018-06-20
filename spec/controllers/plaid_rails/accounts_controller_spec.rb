require 'spec_helper'

module PlaidRails
  describe AccountsController do
    routes { PlaidRails::Engine.routes }
    let(:account){create(:account)}
    let(:public_token){create_public_token}
    let(:client){Plaid::Client.new(env: PlaidRails.env,
                  client_id: PlaidRails.client_id,
                  secret: PlaidRails.secret,
                  public_key: PlaidRails.public_key)}
    let(:access_token){create_access_token}
    
    it "get index" do
      get :index, account:{owner_id: 1}
      expect(response).to be_success
      expect(assigns(:plaid_accounts)).to eq [account]
        
    end
      
    it "get new" do
      get :new, account:{access_token: access_token, name:'Wells Fargo', type: 'wells',
        owner_id: "1", owner_type: "User"}
      expect(response).to be_success
      expect(assigns(:plaid_accounts)).to_not be_nil
      expect(assigns(:plaid_accounts).first.name).to eq('Plaid Checking')
    end
    
    it "can create" do
      accounts = client.accounts.get(access_token).accounts.map{|a| a.account_id}
      post :create, account: {access_token: access_token, account_ids: accounts,
        name:'Wells Fargo', type: 'wells', owner_id: "1", owner_type: "User",
        token: public_token}
      expect(response).to be_success
      expect(assigns(:plaid_accounts).size).to eq 4
      expect(assigns(:plaid_accounts).first.name).to  eq('Plaid Checking')
    end
    
    it "can destroy" do
      delete :destroy, id: account.id
      expect(response).to be_success
      expect(assigns(:plaid_account)).to eq account
    end

  end
end
