require 'spec_helper'

module PlaidRails
  describe LinkController do
    routes { PlaidRails::Engine.routes }
   
    it "authenticate with public token" do
      xhr :post, :authenticate, public_token: 'test,wells,connected', name:'Wells Fargo', type: 'wells',
        owner_id: "1", owner_type: "User"
      expect(response).to be_success
      expect(response).to render_template('plaid_rails/link/authenticate')
    end
    
    it "can't authenticat with bad public token" do
      xhr :post, :authenticate, public_token: 'badtoken', name:'Wells Fargo', type: 'wells',
        owner_id: "1", owner_type: "User"
      expect(response).to_not be_success
      expect(response.status).to eq 500
      expect(response.body).to eq "unauthorized product"
    end
    
    it {
      should permit(:public_token, :type,:name,:owner_id,:owner_type).
        for(:authenticate, verb: :post, format: :js)}

  end
end
