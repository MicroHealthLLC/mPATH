Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  #auth routes
  devise_for :users

  resources :dashboard, only: [:index]
  resources :projects, only: [:index, :show] do
    resources :regions, only: [:index]
    resources :facilities do
      resources :tasks do
        member do
          put :destroy_file
        end
      end
    end
  end

  root 'landing#index'
end
