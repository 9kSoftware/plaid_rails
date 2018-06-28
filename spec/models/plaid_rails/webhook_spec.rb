require 'spec_helper'
module PlaidRails
  describe Webhook do
    describe "validations" do

#      it { should validate_presence_of(:item_id)}
#      it { should validate_presence_of(:webhook_type)}
#      it { should validate_presence_of(:webhook_code)}
    end
    describe "methods" do
      it "calls event" do
        webhook = build(:webhook)
        expect(PlaidRails::Event).to receive(:instrument).with(webhook)
        webhook.save
      end
    end
  end
end
