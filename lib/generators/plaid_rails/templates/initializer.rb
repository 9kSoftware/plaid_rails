Plaid.config do |p|
  Plaid.customer_id = Rails.application.secrets[:plaid][:customer_id]
  Plaid.secret =  Rails.application.secrets[:plaid][:secret]
  Plaid.environment_location = Rails.env.production? ? 'https://api.plaid.com/' : 'https://tartan.plaid.com/'
end
PlaidRails.configure do |config|
  config.public_key =  Rails.application.secrets[:plaid][:public_key]
  config.long_tail = true
  config.webhook = 'https://my.app.com/plaid/webhooks'
  
  # https://plaid.com/docs/#webhook
  #subscribe to plaid webhooks
  config.all do |event|
    Rails.logger.debug "Plaid Webhook: #{event.inspect}"
  end
  
  config.subscribe "transactions.initial" do |event|
    Rails.logger.debug "transactions.initial #{event.inspect}"
    # do something with intial transactions
  end
  config.subscribe "transactions.new" do |event|
    Rails.logger.debug "transactions.new #{event.inspect}"
    # do something with the new transactions
  end
  config.subscribe "transactions.interval" do |event|
    Rails.logger.debug "transactions.initial #{event.inspect}"
    # do something with the new transactions
  end
end
