Rails.application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: 'callbacks'}
  authenticate :user, lambda { |u| u.admin? } do
    ActiveAdmin.routes(self)
  end

  resources :dashboard, only: [:index]
  resources :task_types, only: [:index]
  resources :facility_groups, only: [:index]
  resources :statuses, only: [:index]
  resources :projects, only: [:index, :show] do
    resources :facilities do
      resources :notes, module: :facilities do
        put :destroy_file, on: :member
      end
      resources :tasks do
        member do
          put :destroy_file
        end
      end
    end
  end

  root 'landing#index'
  match "*missing", to: "not_found#index", via: :all
end
