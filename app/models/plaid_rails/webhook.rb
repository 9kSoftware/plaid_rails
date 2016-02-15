module PlaidRails
  class Webhook < ActiveRecord::Base
    
   validates :code, presence: true
   validates :message, presence: true
   validates :access_token, presence: true
  end
end
