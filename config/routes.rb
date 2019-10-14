Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  root 'chatrooms#index'

  resources :chatrooms do
    resources :chatroom_users 
    collection do 
      post :create_conversation
    end
    member do 
      post :hide_chatroom
    end
  end 

  resources :messages
  resources :notifications, only: [:index] do
    post :mark_as_read, on: :collection
    post :mark_as_read, on: :member
  end

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
end

