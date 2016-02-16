PlaidRails::Engine.routes.draw do
  
  match '/webhooks', to: 'webhooks#create',   via: :post
  match '/accounts/:owner_id', to: 'accounts#index', via: :get
  match '/authenticate', to: "link#authenticate", via: :post
end
