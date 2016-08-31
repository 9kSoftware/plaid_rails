require 'spec_helper'

module PlaidRails
  describe AccountsController do
    routes { PlaidRails::Engine.routes }
    let(:account){create(:account)}
    let(:public_token){'test,wells,connected'}
    let(:user){Plaid::User.load(:connect, 'test_wells').upgrade(:info)}
    
    it "get index" do
      get :index, account:{owner_id: 1}
      expect(response).to be_success
      expect(assigns(:accounts)).to eq [account]
        
    end
      
    it "get new" do
      get :new, account:{access_token: 'test_wells', name:'Wells Fargo', type: 'wells',
        owner_id: "1", owner_type: "User"}
      expect(response).to be_success
      expect(assigns(:accounts)).to_not be_nil
    end
    
    it "can create" do
      accounts = user.accounts.map{|a| a.id}
      post :create, account: {access_token: 'test_wells', account_ids: accounts,
        name:'Wells Fargo', type: 'wells', owner_id: "1", owner_type: "User",
        token: public_token}
      expect(response).to be_success
      expect(assigns(:accounts).size).to eq 4
      expect(assigns(:accounts).first.bank_name).to eq 'Wells Fargo'
    end
    
    it "can destroy" do
      delete :destroy, id: account.id
      expect(response).to be_success
    end
    
    #    it {
    #      should permit(:access_token, :type,:name,:owner_id,:owner_type,:account_id).
    #        for(:create, params: {access_token: 'test_wells', account_id: '1', 
    #          name: 'name'})}
    #    it {
    #      should permit(:token, :type,:name,:owner_id,:owner_type).
    #        for(:new, verb: :get, params: {access_token: 'test_wells'})}
  end
end
