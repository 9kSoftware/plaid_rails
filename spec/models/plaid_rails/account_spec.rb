require 'spec_helper'

module PlaidRails
  describe Account do
    it { should validate_presence_of(:access_token)}
    it { should validate_presence_of(:plaid_id)}
    it { should validate_presence_of(:name)}
    it { should belong_to(:owner).with_foreign_key(:owner_id)}
    
    let(:account){FactoryGirl.create(:account)}
    let(:token){create_access_token}
    let(:public_token){create_public_token}
    
    describe 'delete_connect' do
      it "from destroy" do
        expect(account).to receive(:delete_connect)
        account.destroy
      end
    
      it "has error" do
        account = FactoryGirl.create(:account)
        expect(Plaid::Client).to receive(:new).with(env: PlaidRails.env,
          client_id: PlaidRails.client_id,
          secret: PlaidRails.secret,
          public_key: PlaidRails.public_key).and_raise("boom")
        expect(Rails.logger).to receive(:error).exactly(1).times
        account.send(:delete_connect)
      end
    
      it "delete_connect" do
        account = FactoryGirl.create(:account,access_token: token)
        client = double
        item = double
        expect(Plaid::Client).to receive(:new).with(env: PlaidRails.env,
          client_id: PlaidRails.client_id,
          secret: PlaidRails.secret,
          public_key: PlaidRails.public_key).and_return(client)
        expect(client).to receive(:transactions).and_return([1])
        expect(client).to receive(:item).and_return(item)
        expect(item).to receive(:remove).with(token)
        account.send(:delete_connect)
      end
    
      it "does not delete_connect" do
        FactoryGirl.create(:account)
        expect(Plaid::Client).to_not receive(:new).with(env: PlaidRails.env,
          client_id: PlaidRails.client_id,
          secret: PlaidRails.secret,
          public_key: PlaidRails.public_key).and_raise("boom")      
      end
    
      it "does not delete_connect without transactions" do
        user = double
        expect(Plaid::Client).to receive(:new).with(env: PlaidRails.env,
          client_id: PlaidRails.client_id,
          secret: PlaidRails.secret,
          public_key: PlaidRails.public_key).and_return(user)
        expect(user).to receive(:transactions).and_return([])
        account.update(access_token: 'foobar')
      end
    
      it 'does not delete_connect with same access_token' do
        2.times{FactoryGirl.create(:account) }
        expect(Plaid::Client).to_not receive(:new).with(env: PlaidRails.env,
          client_id: PlaidRails.client_id,
          secret: PlaidRails.secret,
          public_key: PlaidRails.public_key)
        Account.first.destroy
      end
    end
    
    describe "delete_updated_token" do
      it "before_update delete_updated_token" do
        expect(account).to receive(:delete_updated_token)
        account.update(access_token: 'foobar')
      end
    
      it "does not before_update delete_connect" do
        expect(account).to_not receive(:delete_updated_token)
        account.update(last_sync: Time.now)
      end
      
      it 'does delete_connect' do
        expect(account).to receive(:delete_connect)
        account.send(:delete_updated_token)
      end
    end
  end
end
