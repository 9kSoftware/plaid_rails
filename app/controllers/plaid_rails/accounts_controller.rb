require_dependency "plaid_rails/application_controller"

module PlaidRails
  class AccountsController < ApplicationController
    
    def index
      @plaid_accounts =PlaidRails::Account.where(owner_id: account_params[:owner_id])
    end
    
    # display list of accounts for authenticated user
    def new
      client = Plaid::Client.new(env: PlaidRails.env,
        client_id: PlaidRails.client_id,
        secret: PlaidRails.secret,
        public_key: PlaidRails.public_key)

      response = client.accounts.get(account_params["access_token"])
      @plaid_accounts = response.accounts
      
    end
    
    #create new bank account and return all the accounts for the owner
    def create
      @plaid_accounts = PlaidRails::CreateAccountService.call(account_params)
    end
    
    def update
      
    end
    
    def destroy
      @plaid_account = PlaidRails::Account.find(params[:id])
      @plaid_account.destroy
    end
    
    # retreive the stripe token 
    # /accounts/:account_id/stripe_token
    def stripe_token
      plaid_account = PlaidRails::Account.find(params[:id])
      client = Plaid::Client.new(env: PlaidRails.env,
        client_id: PlaidRails.client_id,
        secret: PlaidRails.secret,
        public_key: PlaidRails.public_key)
      stripe_response = client.processor.stripe.bank_account_token.
        create(plaid_account.access_token, plaid_account.plaid_id)
      bank_account_token = stripe_response['stripe_bank_account_token']
      plaid_account.update(stripe_token: bank_account_token)
      render json: {id: bank_account_token}
    end
    
    private
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:access_token, :type,:name,
        :owner_id,:owner_type, :transactions_start_date, account_ids:[])
    end
  end
end
