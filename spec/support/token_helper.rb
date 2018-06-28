require 'rest-client'
module TokenHelper
  def create_public_token
    response =  RestClient.post('https://sandbox.plaid.com/sandbox/public_token/create',
      { "public_key"=> PlaidRails.public_key,
        "institution_id"=> "ins_109508",
        "initial_products"=> ['auth','transactions']}.to_json, 
      {content_type: :json, accept: :json})
    if response.code==200
      JSON.parse(response.body)['public_token']
    else
      Rails.logger.error "unable to create token: #{response.body}"
    end
  end
  
  def create_access_token
    public_token = create_public_token
    client = Plaid::Client.new(env: PlaidRails.env,
      client_id: PlaidRails.client_id,
      secret: PlaidRails.secret,
      public_key: PlaidRails.public_key)
    exchange_token = client.item.public_token.exchange(public_token)
    exchange_token.access_token
  end
end