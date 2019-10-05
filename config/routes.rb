Rails.application.routes.draw do

  resources :chatrooms do
    resources :chatroom_users 
    resources :messages
    collection do 
      post :create_one_on_one
    end
    member do 
      post :hide_chatroom
    end
  end 

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  root 'chatrooms#index'

  namespace :api do 
    namespace :v2 do
      resources :chatrooms ,only:[:show] do 
        member do 
          get :get_relative_users
          get :get_users
          get :get_tags
          get :get_messages
          get :next_messages
        end
      end
    end
  end

  resources :notifications, only: [:index] do
    post :mark_as_read, on: :collection
    post :mark_as_read, on: :member
  end
end

