Rails.application.routes.draw do
  resources :chatrooms do
    resources :chatroom_users do 
      collection do 
        post :join
      end 
    end
    resources :messages
  end 
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'chatrooms#index'
  namespace :api do 
    namespace :v2 do
      resources :chatrooms ,only:[:show] do 
        member do 
          get :show_users
          get :show_tags
          get :show_messages
        end
      end
    end
  end
end

