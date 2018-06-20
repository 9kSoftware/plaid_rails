module PlaidRails
  class Webhook < ActiveRecord::Base
    
    #    validates :code, presence: true
    #    validates :message, presence: true
    #    validates :access_token, presence: true
    #    validates :webhook_type, presence: true
    #    validates :webhook_code, presence: true
    #    validates :item_id, presence: true
    serialize :removed_transactons, Array
    after_save :event
   
    private
    def event
      PlaidRails::Event.instrument(self)
    end
  end
end
