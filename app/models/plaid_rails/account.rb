module PlaidRails
  class Account < ActiveRecord::Base
    belongs_to :owner, polymorphic: true, foreign_key: :owner_id
    
    validates :plaid_id, presence: true
    validates :name, presence: true
    validates :access_token, presence: true
    validates :plaid_type, presence: true
  end
end
