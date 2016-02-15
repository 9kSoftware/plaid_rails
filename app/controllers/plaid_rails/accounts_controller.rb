require_dependency "plaid_rails/application_controller"

module PlaidRails
  class AccountsController < ApplicationController
    def index
      @accounts =PlaidRails::Account.where(owner_id: params[:owner_id])
    end
  end
end
