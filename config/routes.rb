Rails.application.routes.draw do

  devise_for :users
  authenticate :user, lambda { |u| u.admin? } do
    ActiveAdmin.routes(self)
  end

  resources :dashboard, only: [:index]
  resources :task_types, only: [:index]
  resources :regions, only: [:index]
  resources :projects, only: [:index, :show] do
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
