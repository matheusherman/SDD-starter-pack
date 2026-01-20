Rails.application.routes.draw do
  # Web pages
  get '/login', to: 'pages#login'
  get '/register', to: 'pages#register'
  get '/products', to: 'pages#products'
  get '/products/:id', to: 'pages#product_details'
  get '/cart', to: 'pages#cart'
  get '/checkout', to: 'pages#checkout'
  get '/order-confirmation/:id', to: 'pages#order_confirmation'
  get '/orders', to: 'pages#orders'
  get '/admin', to: 'pages#admin'
  get '/forgot-password', to: 'pages#forgot_password'
  get '/reset-password', to: 'pages#reset_password'
  root 'pages#login'

  namespace :api do
    resources :products, only: [:index, :create, :show, :update, :destroy]
    resources :users, only: [:create]
    
    # Cart routes
    get '/cart', to: 'carts#show'
    delete '/carts/clear', to: 'carts#clear'
    
    # Cart items routes mapped to /api/cart/items
    resources :cart_items, path: 'cart/items', only: [:create, :update, :destroy]
    
    # Order routes
    resources :orders, only: [:create, :index, :show]
    
    # Auth routes
    namespace :auth do
      post :login
      post :forgot_password
      post :reset_password
    end
  end
end
