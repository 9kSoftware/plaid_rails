PlaidRails::Engine.routes.draw do
  
  resources :accounts do
    member do
      get :stripe_token
    end 
  end
    
  match '/webhooks', to: 'webhooks#create',   via: :post
  match '/authenticate', to: "link#authenticate", via: :post
  match '/update', to: "link#update", via: :post
  match 'create_token', to: 'link#create_token', via: :post
end
