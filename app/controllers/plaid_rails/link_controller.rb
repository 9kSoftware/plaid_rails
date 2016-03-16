require_dependency "plaid_rails/application_controller"

module PlaidRails
  class LinkController < ApplicationController

    def authenticate
      begin
        @exchange_token = Plaid.exchange_token(link_params[:public_token])

        @params = link_params.merge!(token: link_params[:public_token])
        
      rescue => e
        Rails.logger.error "Error: #{e}"
        Rails.logger.error e.backtrace.join("\n")
        render text: e.message, status: 500
      end
    end
    
    def update
      begin
        exchange_token = Plaid.exchange_token(link_params[:public_token])

        @accounts =PlaidRails::Account.where(owner_type: link_params[:owner_type],
        owner_id: link_params[:owner_id])
        @accounts.each do |account|
          account.update(access_token: exchange_token.access_token)
        end
        flash[:success]="You have successfully updated your account(s)"
      rescue => e
        Rails.logger.error "Error: #{e}"
        Rails.logger.error e.backtrace.join("\n")
        render text: e.message, status: 500
      end
    end
    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.permit(:access_token, :public_token, :type,:name,:owner_id,:owner_type)
    end
  end
end
