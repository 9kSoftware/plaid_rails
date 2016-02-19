module PlaidRails
  class WebhooksController < ApplicationController
    skip_before_filter :verify_authenticity_token
    
    def create
      @webhook = PlaidRails::Webhook.create!(webhook_params)
      render json: @webhook
    end
    
    private
    def webhook_params
      params.require(:webhook).permit(:code, :message, :access_token)
    end
  end
end
