PlaidRails::Engine.routes.draw do
  
  resources :accounts
    
  match '/webhooks', to: 'webhooks#create',   via: :post
  match '/authenticate', to: "link#authenticate", via: :post
  

end
