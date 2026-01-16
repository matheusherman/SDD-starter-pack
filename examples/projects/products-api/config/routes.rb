Rails.application.routes.draw do
  namespace :api do
    resources :products, only: [:index, :create, :update, :destroy]
    resources :users, only: [:create]
    
    namespace :auth do
      post :login
    end
  end
end
