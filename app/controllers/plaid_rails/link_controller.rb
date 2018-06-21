require_dependency "plaid_rails/application_controller"

module PlaidRails
  class LinkController < ApplicationController

    # /plaid/authenticate
    def authenticate
      begin
        client = Plaid::Client.new(env: PlaidRails.env,
          client_id: PlaidRails.client_id,
          secret: PlaidRails.secret,
          public_key: PlaidRails.public_key)
        @exchange_token = client.item.public_token.exchange(link_params[:public_token])
        @params = link_params.merge!(token: link_params[:public_token])
        
      rescue => e
        Rails.logger.error "Error: #{e}"
        render text: e.message, status: 500
      end
    end
    
    # updates the access token after changing password with institution  
    # /plaid/update
    def update
      begin
        client = Plaid::Client.new(env: PlaidRails.env,
          client_id: PlaidRails.client_id,
          secret: PlaidRails.secret,
          public_key: PlaidRails.public_key)
        exchange_token = client.item.public_token.exchange(link_params[:public_token])
        
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
    
    # creates a new public token
    # /plaid/create_token
    def create_token
      client = Plaid::Client.new(env: PlaidRails.env,
        client_id: PlaidRails.client_id,
        secret: PlaidRails.secret,
        public_key: PlaidRails.public_key)
      if link_params['access_token']
      response = client.item.public_token.create(link_params['access_token'])
      render json: {public_token: response['public_token']}.to_json
      else
        render json: {error: 'missing access_token'}.to_json, status: 500
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
