require "plaid_rails/engine"
require "plaid_rails/event"
require "plaid"

module PlaidRails
  
  class << self
    attr_accessor :customer_id,
      :secret,
      :environment_location,
      :public_key,
      :webhook,
      :longtail,
      :env
   
    
    def configure(&block)
      raise ArgumentError, "must provide a block" unless block_given?
      block.arity.zero? ? instance_eval(&block) : yield(self)
    end
    
    def subscribe(name, callable = Proc.new)
      PlaidRails::Event.subscribe(name, callable)
    end
    
    def instrument(name, object)
      PlaidRails::Event.backend.instrument( PlaidRails::Event.namespace.call(name), object)
    end

    def all(callable = Proc.new)
      PlaidRails::Event.all(callable)
    end
    
  end
end
