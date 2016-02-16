require_dependency "plaid_rails/application_controller"

module PlaidRails
  class LinkController < ApplicationController

    def authenticate
      begin
        access_token = Plaid.exchange_token(params[:public_token])
        
        PlaidRails::Account.create!(
          access_token: access_token, 
          plaid_type: params[:type],
          name: params[:name],
          owner_id: params[:owner_id],
          owner_type: params[:owner_type]
        ) unless PlaidRails::Account.exists?(owner_id: params[:owner_id], 
          owner_type: params[:owner_type], plaid_type: params[:type])
        
        @banks_accounts = PlaidRails::Account.where(owner_id: params[:owner_id], owner_type: params[:owner_type])
      rescue => e
        Rails.logger.error "Error: #{e}"
        
      end
    end
  end
end
