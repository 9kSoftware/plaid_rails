require 'spec_helper'

module PlaidRails
  describe Account do
    it { should validate_presence_of(:access_token)}
    it { should validate_presence_of(:plaid_id)}
    it { should validate_presence_of(:plaid_type)}
    it { should validate_presence_of(:name)}
    it { should belong_to(:owner).with_foreign_key(:owner_id)}
    
    let(:account){FactoryGirl.create(:account)}
    
    it "expect to call delete_connect" do
      expect(account).to receive(:delete_connect)
      account.destroy
    end
    
    it "delete connect with error" do
      account = FactoryGirl.create(:account)
      expect(Plaid::Connection).to receive(:delete).with('connect', 
        { access_token: 'test_wells'}).and_raise("boom")
      expect(Rails.logger).to receive(:error).exactly(2).times
      account.send(:delete_connect)
    end
    
    it "delete_connect" do
      account = FactoryGirl.create(:account)
      expect(Plaid::Connection).to receive(:delete).with('connect', 
        { access_token: 'test_wells'})
      account.send(:delete_connect)
    end
    
    it "does not delete_connect" do
      FactoryGirl.create(:account)
      expect(Plaid::Connection).to_not receive(:delete).with('connect', 
        { access_token: 'test_wells'})
      account.send(:delete_connect)
    end
  end
end
