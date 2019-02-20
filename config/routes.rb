Rails.application.routes.draw do
  devise_for :users
  get 'home/index'

  root to: 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api, defaults: { format: :json } do
    scope module: :v1 do
      resources :users, only: [:show, :create, :update, :destroy] do
        resources :toys, only: [:create]
      end
      resources :toys, only: [:show, :create]
    end
  end

end
