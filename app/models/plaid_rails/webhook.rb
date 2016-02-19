module PlaidRails
  class Webhook < ActiveRecord::Base
    
    validates :code, presence: true
    validates :message, presence: true
    validates :access_token, presence: true
    after_save :event
   
    private
    def event
      PlaidRails::Event.instrument(self)
    end
  end
end
