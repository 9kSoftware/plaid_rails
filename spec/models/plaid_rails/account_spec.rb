require 'spec_helper'

module PlaidRails
  describe Account do
    it { should validate_presence_of(:access_token)}
    it { should validate_presence_of(:plaid_id)}
    it { should validate_presence_of(:plaid_type)}
    it { should validate_presence_of(:name)}
    it { should belong_to(:owner).with_foreign_key(:owner_id)}
  end
end
