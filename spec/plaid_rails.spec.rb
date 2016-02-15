require 'spec_helper'

module PlaidRails
  describe "#configure" do
    it "should pass the class back to the given block" do
      PlaidRails.configure do |plaid_rails|
        expect(plaid_rails).to eq plaid_rails
      end
    end
  end
  
  describe "instrumentation" do
    it "should pass subscribe to PlaidRails::Event" do
      expect(PlaidRails::Event).to receive(:subscribe)
      PlaidRails.subscribe('foo', 'blah')
    end
    
    it "should pass instrument to PlaidRails::Event.backend" do
      expect(ActiveSupport::Notifications).to receive(:instrument)
      PlaidRails.instrument('foo', 'blah')
    end
    
    it "should pass all to PlaidRails::Event" do
      expect(PlaidRails::Event).to receive(:all)
      PlaidRails.all('blah')
    end
  end


end