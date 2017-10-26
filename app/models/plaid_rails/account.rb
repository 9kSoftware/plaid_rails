module PlaidRails
  class Account < ActiveRecord::Base
    belongs_to :owner, polymorphic: true, foreign_key: :owner_id
    
    before_destroy :delete_connect
    before_update :delete_connect, if: :access_token_changed?
    
      validates :plaid_id, presence: true
      validates :name, presence: true
      validates :access_token, presence: true
      validates :plaid_type, presence: true
    
      private
    
      # delete token from Plaid if there are no more accounts for this token
      def delete_connect
        # check if access token changed and use that token 
        # means the bank password was changed
        if self.access_token_changed?
          token = self.access_token_was 
        else
          token = self.access_token
        end
        
        # hide full token from logs
        token_last_8 =  token[-8..-1]
        
        Rails.logger.debug "Deleting Plaid User with token #{token_last_8}"
        begin
          if PlaidRails::Account.where(access_token: token).size > 0
            user = Plaid::User.load(:connect, token)
            # skip delete if there are no transactions
            if user.transactions.any?
              user.delete 
              Rails.logger.debug "Deleted Plaid User with token #{token_last_8}"
            end
          end
        rescue  => e
          message = "Unable to delete user with token #{token_last_8}"
          Rails.logger.error "#{message}: #{e.message}"
        end
      end
    end
  end
