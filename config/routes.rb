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
  end

  resources :dashboard, only: [:index]
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

  get '/settings', to: 'settings#index'
  post '/settings', to: 'settings#update'
  get '/facility_groups', to: 'data#facility_groups'
  get '/task_types', to: 'data#task_types'
  get '/statuses', to: 'data#statuses'

  root 'landing#index'
  match "*missing", to: "not_found#index", via: :all
end
