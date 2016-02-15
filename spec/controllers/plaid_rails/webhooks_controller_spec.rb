require 'spec_helper'
module PlaidRails
  describe WebhooksController do
    routes { PlaidRails::Engine.routes }
    
    it "create webhook" do
      params={"code"=> "0", "message"=> "hello", "access_token"=> "foo", 
        "controller"=> "plaid_rails/webhooks", "action"=> "create"}
      expect(PlaidRails::Webhook).to receive(:create).with(params).
        and_return({code: 0, message: "hello", access_token: 'foo'})
      post :create,  params, format: :json
      expect(response.status).to eq 200
      parsed_body = JSON.load(response.body)
      expect(parsed_body['access_token']).to eq "foo"
    end
    
  end
end
