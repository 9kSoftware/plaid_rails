module PlaidRails
  class Account < ActiveRecord::Base
    belongs_to :owner, polymorphic: true, foreign_key: :owner_id
    
    before_destroy :delete_connect, :unless=> :accounts_with_same_token?
    before_update :delete_updated_token, :if=> :access_token_changed?
    
    validates :plaid_id, presence: true
    validates :name, presence: true
    validates :access_token, presence: true
    
    private
    
    # delete token from Plaid if there are no more accounts for this token
    def delete_updated_token
      # change all matching tokens on update
      accounts = PlaidRails::Account.where(access_token: my_token)
      if  accounts.size > 0
        delete_connect
      end
    end
    
    # delete Plaid user  
    def delete_connect
      begin
        Rails.logger.info "Deleting Plaid User with token #{token_last_8}"
        client = Plaid::Client.new(env: PlaidRails.env,
          client_id: PlaidRails.client_id,
          secret: PlaidRails.secret,
          public_key: PlaidRails.public_key)
        # skip delete if there are no transactions
        if client.transactions.any?
          client.item.remove(access_token)
          Rails.logger.info "Deleted Plaid User with token #{token_last_8}"
        end
      rescue  => e
        message = "Unable to delete user with token #{token_last_8}"
        Rails.logger.error "#{message}: #{e.message}"
      end
    end
      
    # check if access token changed and use that token 
    # means the bank password was changed
    # return token changed token if it was changed
    def my_token
      self.access_token_changed? ? self.access_token_was : self.access_token
    end
      
    # hide full token from logs
    def token_last_8
      my_token[-8..-1]
    end
    
    # are there more accounts that use the same token
    def accounts_with_same_token?
      PlaidRails::Account.where(access_token: my_token).size > 1
    end
  end
end
