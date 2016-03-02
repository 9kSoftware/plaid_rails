require_dependency "plaid_rails/application_controller"

module PlaidRails
  class AccountsController < ApplicationController
    
    def index
      @accounts =PlaidRails::Account.where(owner_id: account_params[:owner_id])
    end
    
    # display list of accounts for authenticated user
    def new
      @user = Plaid.set_user(account_params[:access_token], ['auth'])
      # Retrieve the user's accounts
      @user.get('auth')
      @accounts = @user.accounts
    end
    
    #create new bank account and return all the accounts for the owner
    def create
      @accounts = PlaidRails::CreateAccountService.call(account_params)
    end
    
    def update
      
    end
    
    def destroy
      account = PlaidRails::Account.find(params[:id])
      account.destroy
    end
    
    private
    
    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
      params.require(:account).permit(:token,:access_token, :type,:name,:owner_id,:owner_type,account_ids:[])
    end
  end
end
