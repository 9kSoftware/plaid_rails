require "active_support/notifications"

module PlaidRails
  module Event
    class << self
      attr_accessor :adapter, :backend, :namespace

      def configure(&block)
        raise ArgumentError, "must provide a block" unless block_given?
        block.arity.zero? ? instance_eval(&block) : yield(self)
      end
      alias :setup :configure
      
      def instrument(event)
        name = case event.code
        when 0
          "transactions.initial"
        when 1
          "transactions.new"
        when 2
          "transactions.interval"
        when 3
          "transactions.removed"
        when 4
          "webhook.updated"
        else
          "plaid.error"
        end
        backend.instrument namespace.call(name), event if event
      end
      
      def subscribe(name, callable = Proc.new)
        backend.subscribe namespace.to_regexp(name), adapter.call(callable)
      end

      def all(callable = Proc.new)
        subscribe nil, callable
      end

      def listening?(name)
        namespaced_name = namespace.call(name)
        backend.notifier.listening?(namespaced_name)
      end
    end
  
    class Namespace < Struct.new(:value, :delimiter)
      def call(name = nil)
        "#{value}#{delimiter}#{name}"
      end

      def to_regexp(name = nil)
        %r{^#{Regexp.escape call(name)}}
      end
    end

    class NotificationAdapter < Struct.new(:subscriber)
      def self.call(callable)
        new(callable)
      end

      def call(*args)
        payload = args.last
        subscriber.call(payload)
      end
    end

    class Error < StandardError; end
    class UnauthorizedError < Error; end

    self.adapter = NotificationAdapter
    self.backend = ActiveSupport::Notifications
    self.namespace = Namespace.new("plaid_rails", ".")
  end
end
