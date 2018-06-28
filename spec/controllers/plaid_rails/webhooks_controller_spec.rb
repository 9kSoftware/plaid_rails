require 'spec_helper'
module PlaidRails
  describe WebhooksController do
    routes { PlaidRails::Engine.routes }
    
    it "create webhook" do
      params={"webhook"=>{
          "webhook_type"=> "TRANSACTIONS",
          "webhook_code"=> "INITIAL_UPDATE",
          "item_id"=> "wz666MBjYWTp2PDzzggYhM6oWWmBb",
          "error"=> nil,
          "new_transactions"=> 19
        }}

      expect{post :create,  params, format: :json}.to change{PlaidRails::Webhook.count}.by(1)
      expect(response.status).to eq 200
      parsed_body = JSON.load(response.body)
      expect(parsed_body['item_id']).to eq "wz666MBjYWTp2PDzzggYhM6oWWmBb"
      expect(parsed_body['webhook_type']).to eq "TRANSACTIONS"
      
    end
    
    it "notifiy INITIAL_UPDATE" do
      params = {"webhook"=>{
          "webhook_type"=> "TRANSACTIONS",
          "webhook_code"=> "INITIAL_UPDATE",
          "item_id"=> "wz666MBjYWTp2PDzzggYhM6oWWmBb",
          "error"=> nil,
          "new_transactions"=> 19
        }}
      expect(Rails.logger).to receive(:debug).with(/transactions.initial/).at_least(:once)
      expect{post :create,  params, format: :json}.to change{PlaidRails::Webhook.count}.by(1)
    end
    it "notifiy HISTORICAL_UPDATE" do
      params = {"webhook"=>{
          "webhook_type"=> "TRANSACTIONS",
          "webhook_code"=> "HISTORICAL_UPDATE",
          "item_id"=> "wz666MBjYWTp2PDzzggYhM6oWWmBb",
          "error"=> nil,
          "new_transactions"=> 19
        }}
      expect(Rails.logger).to receive(:debug).with(/transactions.new/).at_least(:once)
      expect{post :create,  params, format: :json}.to change{PlaidRails::Webhook.count}.by(1)
    end
    it "notifiy DEFAULT_UPDATE" do
      params = {"webhook"=>{
          "webhook_type"=> "TRANSACTIONS",
          "webhook_code"=> "DEFAULT_UPDATE",
          "item_id"=> "wz666MBjYWTp2PDzzggYhM6oWWmBb",
          "error"=> nil,
          "new_transactions"=> 19
        }}
      expect(Rails.logger).to receive(:debug).with(/transactions.interval/).at_least(:once)
      expect{post :create,  params, format: :json}.to change{PlaidRails::Webhook.count}.by(1)
    end
    it "notifiy TRANSACTIONS_REMOVED" do
      params = {"webhook"=>{
          "webhook_type"=> "TRANSACTIONS",
          "webhook_code"=> "TRANSACTIONS_REMOVED",
          "item_id"=> "wz666MBjYWTp2PDzzggYhM6oWWmBb",
          "error"=> nil,
          "new_transactions"=> 19
        }}
      expect(Rails.logger).to receive(:debug).with(/transactions.removed/).at_least(:once)
      expect{post :create,  params, format: :json}.to change{PlaidRails::Webhook.count}.by(1)
    end
    
    it "notifiy WEBHOOK_UPDATE_ACKNOWLEDGED" do
      params = {"webhook"=>{
          "webhook_type"=> "ITEM",
          "webhook_code"=> "WEBHOOK_UPDATE_ACKNOWLEDGED",
          "item_id"=> "wz666MBjYWTp2PDzzggYhM6oWWmBb",
          "error"=> nil,
          "new_transactions"=> 19
        }}
      expect(Rails.logger).to receive(:debug).with(/webhook.updated/).at_least(:once)
      expect{post :create,  params, format: :json}.to change{PlaidRails::Webhook.count}.by(1)
    end
    it "notifiy ERROR" do
      params = {"webhook"=>{
          "webhook_type"=> "ITEM",
          "webhook_code"=> "ERROR",
          "item_id"=> "wz666MBjYWTp2PDzzggYhM6oWWmBb",
          "error"=> nil,
          "new_transactions"=> 19
        }}
      expect(Rails.logger).to receive(:debug).with(/plaid.error/).at_least(:once)
      expect{post :create,  params, format: :json}.to change{PlaidRails::Webhook.count}.by(1)
    end
  end
  
end
