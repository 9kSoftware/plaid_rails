require 'spec_helper'
module PlaidRails
  describe Webhook do
    describe "validations" do

      it { should validate_presence_of(:code)}
      it { should validate_presence_of(:message)}
      it { should validate_presence_of(:access_token)}
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
