require 'spec_helper'

module PlaidRails
  describe LinkController do
    routes { PlaidRails::Engine.routes }
    render_views
    let(:public_token){create_public_token}
    
    it "authenticate with public token" do
      xhr :post, :authenticate, public_token: public_token, name:'Wells Fargo', type: 'wells',
        owner_id: "1", owner_type: "User"
      expect(response).to be_success
      expect(response).to render_template('plaid_rails/link/authenticate')
    end
    
    it "can't authenticate with bad public token" do
      xhr :post, :authenticate, public_token: 'badtoken', name:'Wells Fargo', type: 'wells',
        owner_id: "1", owner_type: "User"
      expect(response).to_not be_success
      expect(response.status).to eq 500
      expect(response.body).to include "INVALID_PUBLIC_TOKEN"
    end
    
    it "update with public token" do
      account = create(:account, transactions_start_date: Date.today - 3)
      xhr :post, :update, public_token: public_token, name:'Wells Fargo', type: 'wells',
        owner_id: "1", owner_type: "User", number: 1234
      expect(response).to be_success
      expect(assigns(:plaid_accounts)).to_not be_nil
      expect(assigns(:plaid_accounts).first.transactions_start_date).to eq Date.today - 3
      expect(response).to render_template('plaid_rails/link/update')
    end
    
    it "create public token" do
      access_token = create_access_token
      post :create_token, access_token: access_token
      json = JSON.parse(response.body)
      expect(json).to include 'public_token'
    end
    
    it "create public token without access_token" do
      post :create_token
      expect(response).to_not be_successful
    end

  end
end
