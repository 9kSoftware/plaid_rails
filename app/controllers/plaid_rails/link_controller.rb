require_dependency "plaid_rails/application_controller"

module PlaidRails
  class LinkController < ApplicationController

    def authenticate
      begin
        @exchange_token = Plaid::User.exchange_token(link_params[:public_token])

        @params = link_params.merge!(token: link_params[:public_token])
        
      rescue => e
        Rails.logger.error "Error: #{e}"
        Rails.logger.error e.backtrace.join("\n")
        render text: e.message, status: 500
      end
    end
    
    # updates the access token after changing password with institution  
    def update
      begin
        exchange_token = Plaid::User.exchange_token(link_params[:public_token])
        
        # find old access_token
        old_access_token = PlaidRails::Account.find_by(owner_type: link_params[:owner_type],
        owner_id: link_params[:owner_id],number: link_params[:number]).access_token
        
        # find all plaid_accounts with old access_token 
        accounts = PlaidRails::Account.where(owner_type: link_params[:owner_type],
        owner_id: link_params[:owner_id], access_token: old_access_token)
      
        # update found accounts with new token.
        accounts.update_all(access_token: exchange_token.access_token, 
            transactions_start_date: Date.today)
    
        # get all accounts to display back to user.
        @plaid_accounts = PlaidRails::Account.where(owner_type: link_params[:owner_type],
        owner_id: link_params[:owner_id])
      
        flash[:success]="You have successfully updated your account(s)"
      rescue => e
        Rails.logger.error "Error: #{e}"
        render text: e.message, status: 500
      end
    end
    
    private
    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.permit(:access_token, :public_token, :type,:name,:owner_id,
        :owner_type,:number)
    end
  end
end
