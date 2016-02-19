require 'spec_helper'
module PlaidRails
  describe WebhooksController do
    routes { PlaidRails::Engine.routes }
    
    it "create webhook" do
      params={"webhook"=>{"code"=> "0", "message"=> "hello", "access_token"=> "test_wells"}}
      expect(PlaidRails::Webhook).to receive(:create!).with(params["webhook"]).
        and_return({code: 0, message: "hello", access_token: 'test_wells'})

      post :create,  params, format: :json
      expect(response.status).to eq 200
      parsed_body = JSON.load(response.body)
      expect(parsed_body['access_token']).to eq "test_wells"
    end
    
  end
end
