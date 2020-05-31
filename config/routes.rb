Rails.application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: 'callbacks'}
  authenticate :user, lambda { |u| u.admin? } do
    begin
      ActiveAdmin.routes(self)
    rescue Exception => e
      puts "ActiveAdmin: #{e.class}: #{e}"
    end
  end

  namespace :api, defaults: { format: :json } do
    resources :task_types, only: [:index]
    resources :facility_groups, only: [:index]
    resources :statuses, only: [:index]
    resources :issue_statuses, only: [:index]
    resources :issue_severities, only: [:index]
    resources :issue_types, only: [:index]
    get '/settings', to: 'settings#index'
    post '/settings', to: 'settings#update'
  end

  resources :dashboard, only: [:index]
  resources :projects, only: [:index, :show] do
    resources :facilities do
      resources :issues
      resources :notes, module: :facilities do
        put :destroy_file, on: :member
      end
      resources :tasks do
        put :destroy_file, on: :member
      end
    end
  end
  resources :facilities, only: [] do
    resources :facility_projects, only: [:index, :update, :show]
  end

  get '/profile', to: 'profiles#index'
  post '/profile', to: 'profiles#update'
  get '/current_user', to: 'profiles#current_profile'
  get '/settings', to: 'data#settings'
  get '/facility_groups', to: 'data#facility_groups'
  get '/task_types', to: 'data#task_types'
  get '/statuses', to: 'data#statuses'

  root 'landing#index'
  mount ActiveStorage::Engine, at: '/rails/active_storage'

  if Rails.env.production?
    get '*all', to: "not_found#index", constraints: -> (req) do
      req.path.exclude? 'rails/active_storage'
    end
  end
end
