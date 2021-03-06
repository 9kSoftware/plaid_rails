
PlaidRails.configure do |config|
  config.client_id = Rails.application.secrets[:plaid][:client_id]
  config.secret = Rails.application.secrets[:plaid][:secret]
  config.public_key =  Rails.application.secrets[:plaid][:public_key]
  config.longtail = true
  config.env =  Rails.env.production? ? "production" : "sandbox"
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
