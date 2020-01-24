Rails.application.routes.draw do
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  #auth routes
  devise_for :users
  
  resources :dashboard, only: [:index]
  resources :projects, only: [:index, :show] do 
    resources :facilities
  end
  resources :regions, only: [:index]
  
  root 'landing#index'  
end
