module PlaidRails
  class WebhooksController < ApplicationController
    
    def create
      @webhook = PlaidRails::Webhook.create(params)
      render json: @webhook
    end
    
  end
end
