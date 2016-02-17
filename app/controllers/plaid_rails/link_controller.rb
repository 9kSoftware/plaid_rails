require_dependency "plaid_rails/application_controller"

module PlaidRails
  class LinkController < ApplicationController

    def authenticate
      begin
        @exchange_token = Plaid.exchange_token(link_params[:public_token])

        @params = link_params
        
      rescue => e
        Rails.logger.error "Error: #{e}"
        Rails.logger.error e.backtrace.join("\n")
        render text: e.message, status: 500
      end
    end
    
    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.permit(:public_token, :type,:name,:owner_id,:owner_type)
    end
  end
end
