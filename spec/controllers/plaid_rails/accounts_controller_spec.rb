require 'spec_helper'

module PlaidRails
  describe AccountsController do
    routes { PlaidRails::Engine.routes }
    let(:account){create(:account)}
    

      it "get index" do
        get :index, owner_id: 1
        expect(response).to be_success
        expect(assigns(:accounts)).to eq [account]
        
      end

    

  end
end
