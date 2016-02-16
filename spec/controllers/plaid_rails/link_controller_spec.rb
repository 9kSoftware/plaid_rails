require 'spec_helper'

module PlaidRails
  describe LinkController do
    routes { PlaidRails::Engine.routes }
   
    it "authenticate with public token" do
      expect(Plaid).to receive(:exchange_token).with('foo').and_return('mytoken')
      xhr :post, :authenticate, public_token: 'foo', name:'Wells Fargo', type: 'wells',
        owner_id: "1", owner_type: "User", account_id: 'abc123'
      response.should be_success
      expect(PlaidRails::Account.count).to eq 1
      expect(response).to render_template('plaid_rails/link/authenticate')
    end
  end
end
