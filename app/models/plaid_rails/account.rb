module PlaidRails
  class Account < ActiveRecord::Base
    belongs_to :owner, polymorphic: true, foreign_key: :owner_id
    
    before_destroy :delete_connect
    before_save :delete_connect, if: Proc.new{|a| a.access_token_changed? and !a.new_record?}
    
    validates :plaid_id, presence: true
    validates :name, presence: true
    validates :access_token, presence: true
    validates :plaid_type, presence: true
    
    private
    
    # delete token from Plaid if there are no more accounts for this token
    def delete_connect
      token = self.access_token
      begin
        if PlaidRails::Account.where(access_token: token).size == 1
          user = Plaid::User.load(:connect, token)
          user.delete
        end
      rescue  => e
        message = "Unable to delete token #{token}"
        Rails.logger.error "#{message}: #{e.message}"
        Rails.logger.error e.backtrace.join("\n")
      end
    end
  end
end
