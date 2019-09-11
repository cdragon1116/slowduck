Rails.application.routes.draw do
  resources :chatrooms do 
    resources :posts do
        resources :messages, only: [:create ,:destroy]
    end
  end 
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'chatrooms#index'
end
