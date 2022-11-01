Rails.application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}
  authenticate :user, lambda {|u| u.admin?} do
    begin
      ActiveAdmin.routes(self)
    rescue Exception => e
      puts "ActiveAdmin: #{e.class}: #{e}"
    end
  end

  namespace :api, defaults: {format: :json} do
    namespace :v1 do

      # Program settings routes
      namespace :program_settings do

        resources :projects, path: 'programs' do
          collection do
            post :add_contract
            post :add_contract_vehicle
          end
        end
  
        resources :contract_vehicles

        resources :contracts
        
        resources :facility_groups do
          collection do
            put :bulk_project_update
          end
        end
  
        resources :facilities do
          collection do
            put :bulk_projects_update
            delete :remove_facility_project
          end
        end

        resources :roles do
          collection do
            post :remove_role
            post :update_role_users
          end
          member do
            post :add_users
          end
        end
        
        resources :users do
          collection do
            post :add_to_program
            delete :remove_from_program
            get :get_user_privileges
          end
        end

        get "/contract_data/get_contract_data", to: "contract_data#get_contract_data"
        get "/contract_data/contract_types", to: "contract_data#contract_types"
        get "/contract_data/contract_statuses", to: "contract_data#contract_statuses"
        get "/contract_data/contract_customeres", to: "contract_data#contract_customeres"
        get "/contract_data/contract_vehicles", to: "contract_data#contract_vehicles"
        get "/contract_data/contract_vehicle_number", to: "contract_data#contract_vehicle_number"
        get "/contract_data/contract_number", to: "contract_data#contract_number"
        get "/contract_data/subcontract_number", to: "contract_data#subcontract_number"
        get "/contract_data/contract_prime", to: "contract_data#contract_prime"
        get "/contract_data/contract_current_pop", to: "contract_data#contract_current_pop"
        get "/contract_data/contract_classification", to: "contract_data#contract_classification"
        get "/contract_data/contract_client_types", to: "contract_data#contract_client_types"
        get "/contract_data/contract_sub_categories", to: "contract_data#contract_sub_categories"
        get "/contract_data/contract_agencies", to: "contract_data#contract_agencies"
        get "/contract_data/contract_vehicle_types", to: "contract_data#contract_vehicle_types"
        get "/contract_data/contract_award_tos", to: "contract_data#contract_award_tos"
        get "/contract_data/contract_naics", to: "contract_data#contract_naics"
        get "/contract_data/contract_award_types", to: "contract_data#contract_award_types"
        get "/contract_data/contract_pocs", to: "contract_data#contract_pocs"

        post "/contract_data/contract_client_types", to: "contract_data#create_contract_category"
        post "/contract_data/contract_categories", to: "contract_data#create_contract_client_type"
        post "/contract_data/contract_type", to: "contract_data#create_contract_type"
        post "/contract_data/contract_status", to: "contract_data#create_contract_status"
        post "/contract_data/contract_customer", to: "contract_data#create_contract_customer"
        post "/contract_data/contract_vehicle", to: "contract_data#create_contract_vehicle"
        post "/contract_data/contract_vehicle_number", to: "contract_data#create_contract_vehicle_number"
        post "/contract_data/contract_number", to: "contract_data#create_contract_number"
        post "/contract_data/subcontract_number", to: "contract_data#create_subcontract_number"
        post "/contract_data/contract_prime", to: "contract_data#create_contract_prime"
        post "/contract_data/contract_current_pop", to: "contract_data#create_contract_current_pop"
        post "/contract_data/contract_classification", to: "contract_data#create_contract_classification"
      
      end

      # Portfolio routes
      namespace :portfolio do
        resources :contract_vehicles
        resources :contract_project_pocs
        resources :contract_project_data do
          post :add_project, on: :member
        end
        get "/programs", to: "portfolio#programs"
        get "/lessons", to: "portfolio#lessons"
        get "/tasks", to: "portfolio#tasks"
        get "/risks", to: "portfolio#risks"
        get "/issues", to: "portfolio#issues"
        get "/tab_counts", to: "portfolio#tab_counts"
        get "/contracts", to: "portfolio#contracts"
      end
      
      # For Admin panel
      get '/settings', to: 'settings#index'
      post '/settings', to: 'settings#update'
      resources :task_types, only: [:index]
      resources :statuses, only: [:index]
      resources :issue_severities, only: [:index]
      resources :issue_types, only: [:index]
      resources :issue_stages, only: [:index]
      resources :task_stages, only: [:index]
      resources :users do
        collection do
          post :add_to_program
        end
      end
      post '/sort-by', to: 'sorts#update'

      resources :facility_groups do
        collection do
          put :bulk_project_update
        end
      end

      resources :facilities do
        collection do
          put :bulk_projects_update
        end
      end

      resources :project_contract_vehicles do
        resources :notes #, module: :facilities
        resources :issues do
          post :batch_update, on: :collection
          post :create_duplicate, on: :member
          post :create_bulk_duplicate, on: :member
        end
        resources :risks do
          post :batch_update, on: :collection
          post :create_duplicate, on: :member
          post :create_bulk_duplicate, on: :member
        end
        resources :tasks do
          post :batch_update, on: :collection
          post :create_duplicate, on: :member
          post :create_bulk_duplicate, on: :member
        end

        resources :lessons do
          get :count, on: :collection
        end
      end


      resources :project_contracts do
        resources :notes #, module: :facilities
        resources :issues do
          post :batch_update, on: :collection
          post :create_duplicate, on: :member
          post :create_bulk_duplicate, on: :member
        end
        resources :risks do
          post :batch_update, on: :collection
          post :create_duplicate, on: :member
          post :create_bulk_duplicate, on: :member
        end
        resources :tasks do
          post :batch_update, on: :collection
          post :create_duplicate, on: :member
          post :create_bulk_duplicate, on: :member
        end

        resources :lessons do
          get :count, on: :collection
        end
      end

      # Filter data
      get "/filter_data/programs", to: "filter_data#programs"
      get "/filter_data/users", to: "filter_data#users"
      get "/filter_data/statuses", to: "filter_data#statuses"
      get "/filter_data/categories", to: "filter_data#categories"
      get "/filter_data/stages", to: "filter_data#stages"
      get "/filter_data/issue_types", to: "filter_data#issue_types"
      get "/filter_data/issue_severities", to: "filter_data#issue_severities"
      get "/filter_data/risk_approaches", to: "filter_data#risk_approaches"
      get "/filter_data/risk_priority_level", to: "filter_data#risk_priority_level"

      post '/profile', to: 'profiles#update'
      get '/current_user', to: 'profiles#current_profile'

      resources :projects, path: 'programs', only: [:index, :show] do
        resources :query_filters do
          collection do
            delete "reset" => "query_filters#reset"
          end
        end
        
        member do
          # used in Admin
          get 'task_issues', to: 'projects#task_issues'
        end

        resources :lessons, only: [:index] do
          get :count, on: :collection
        end

        resources :facilities, path: 'projects' do
          resources :facility_projects, only: [:index, :update, :show]

          resources :notes #, module: :facilities
          resources :issues do
            post :batch_update, on: :collection
            post :create_duplicate, on: :member
            post :create_bulk_duplicate, on: :member
          end
          resources :risks do
            post :batch_update, on: :collection
            post :create_duplicate, on: :member
            post :create_bulk_duplicate, on: :member
          end
          resources :tasks do
            post :batch_update, on: :collection
            post :create_duplicate, on: :member
            post :create_bulk_duplicate, on: :member
          end

          resources :lessons do
            get :count, on: :collection
          end
        end
      end

    end
    post '/login' => 'authentication#login'
    
  end

  # For Admin panel
  get '/facility_privileges/facility_privileges_partial' => "facility_privileges#facility_privileges_partial", as: :facility_privileges_partial
  get '/facility_privileges/add_facility_privilege_form' => "facility_privileges#add_facility_privilege_form", as: :add_facility_privilege_form

  get '/contract_privileges/contract_privileges_partial' => "contract_privileges#contract_privileges_partial", as: :contract_privileges_partial
  get '/contract_privileges/add_contract_privilege_form' => "contract_privileges#add_contract_privilege_form", as: :add_contract_privilege_form

  get '/project_privileges/load_form' => "project_privileges#load_form", as: :project_privileges_load_form

  get '/profile' => 'home#profile'

  root 'home#landing'
  mount ActiveStorage::Engine, at: '/rails/active_storage'

  # Strictly matching programs/<program_id>/dataviewer
  get '*all', to: "home#settings", constraints: -> (req) do
    # (p = req.path.split("/")[1] ) && p.split("portfolio").size == 1 && p.split("portfolio").include?("portfolio")
    spath = req.path.split("/")
    i = spath.index("settings")
    # TODO: create regex for pattern programs/<program_id>/dataviewer
    i && (p = spath[i] ) && p.match(/^[settings]+$/)
  end

  # Strictly matching programs/<program_id>/dataviewer
  get '*all', to: "home#contracts", constraints: -> (req) do
    # (p = req.path.split("/")[1] ) && p.split("portfolio").size == 1 && p.split("portfolio").include?("portfolio")
    spath = req.path.split("/")
    i = spath.index("contracts")
    # TODO: create regex for pattern programs/<program_id>/dataviewer
    i && (p = spath[i] ) && p.match(/^[contracts]+$/) && (pp = req.path.split("/")[1] ) && pp.downcase == "portfolio".downcase
  end

  # Strictly matching programs/<program_id>/dataviewer
  get '*all', to: "home#dataviewer", constraints: -> (req) do
    # (p = req.path.split("/")[1] ) && p.split("portfolio").size == 1 && p.split("portfolio").include?("portfolio")
    spath = req.path.split("/")
    i = spath.index("dataviewer")
    # TODO: create regex for pattern programs/<program_id>/dataviewer
    i && (p = spath[i] ) && p.match(/^[dataviewer]+$/)
  end

  # Strictly matching /portfolio
  get '*all', to: "home#portfolio", constraints: -> (req) do
    # (p = req.path.split("/")[1] ) && p.split("portfolio").size == 1 && p.split("portfolio").include?("portfolio")
    # TODO: create regex for pattern /portfolio
    (p = req.path.split("/")[1] ) && p.downcase == "portfolio".downcase #&& p.match(/^[portoflio]+$/)
  end

  get "*path", to: 'home#index', constraints: -> (req) do
    !req.xhr? && req.format.html?
  end
  
  get '*all', to: "not_found#index", constraints: -> (req) do
    req.path.exclude?('rails/active_storage')
  end
end