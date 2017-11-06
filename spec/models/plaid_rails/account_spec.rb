require 'spec_helper'

module PlaidRails
  describe Account do
    it { should validate_presence_of(:access_token)}
    it { should validate_presence_of(:plaid_id)}
    it { should validate_presence_of(:plaid_type)}
    it { should validate_presence_of(:name)}
    it { should belong_to(:owner).with_foreign_key(:owner_id)}
    
    let(:account){FactoryGirl.create(:account)}
    
    describe 'delete_connect' do
      it "from destroy" do
        expect(account).to receive(:delete_connect)
        account.destroy
      end
    
      it "has error" do
        account = FactoryGirl.create(:account)
        expect(Plaid::User).to receive(:load).with(:connect, "test_wells").and_raise("boom")
        expect(Rails.logger).to receive(:error).exactly(1).times
        account.send(:delete_connect)
      end
    
      it "delete_connect" do
        account = FactoryGirl.create(:account)
        user = double
        expect(Plaid::User).to receive(:load).with(:connect, "test_wells").and_return(user)
        expect(user).to receive(:transactions).and_return([1])
        expect(user).to receive(:delete)
        account.send(:delete_connect)
      end
    
      it "does not delete_connect" do
        FactoryGirl.create(:account)
        expect(Plaid::User).to_not receive(:load).with(:connect, "test_wells").and_raise("boom")      
      end
    
      it "does not delete_connect without transactions" do
        user = double
        expect(Plaid::User).to receive(:load).with(:connect, "test_wells").and_return(user)
        expect(user).to receive(:transactions).and_return([])
        account.update(access_token: 'foobar')
      end
    
      it 'does not delete_connect with same access_token' do
        2.times{FactoryGirl.create(:account) }
        expect(Plaid::User).to_not receive(:load).with(:connect, "test_wells")
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
