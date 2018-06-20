module PlaidRails
  class WebhooksController < ApplicationController
    skip_before_filter :verify_authenticity_token
    
    def create
      webhook = PlaidRails::Webhook.create!(webhook_params)
      render json: webhook
    end
    
    private
    def webhook_params
      params.require(:webhook).permit(:webhook_type, :webhook_code,:error, 
        :item_id, :new_transactions, :removed_transactions, :code, :message,:access_token  )
    end
  end
end
