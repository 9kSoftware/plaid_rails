PlaidRails::Engine.routes.draw do
  
  namespace :plaid_rails do
  get 'accounts/index'
  end

  match '/webhooks', to: 'webhooks#create',   via: :post#, as: 'webhook'
  match '/accounts/:owner_id', to: 'accounts#index', via: :get
  
  #resources :accounts
end
