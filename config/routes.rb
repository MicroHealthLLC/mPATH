Rails.application.routes.draw do

  devise_for :users, controllers: {omniauth_callbacks: 'callbacks'}
  authenticate :user, lambda {|u| u.admin?} do
    begin
      ActiveAdmin.routes(self)
    rescue Exception => e
      puts "ActiveAdmin: #{e.class}: #{e}"
    end
  end

  namespace :api, defaults: {format: :json} do
    namespace :v1 do

      # For Admin panel
      namespace :admin do
        resources :facilities do
          resources :facility_projects, only: [:index, :update, :show]
        end
        get '/settings', to: 'settings#index'
        post '/settings', to: 'settings#update'

        resources :task_types, only: [:index]
        # resources :statuses, only: [:index]
        # resources :issue_severities, only: [:index]
        # resources :issue_types, only: [:index]
        # resources :issue_stages, only: [:index]
        # resources :task_stages, only: [:index]
        # resources :users, only: [:index]
        # post '/sort-by', to: 'sorts#update'
      end

      resources :facility_groups, only: [:index, :create]

      resources :contracts

      # Contract data API
      get "/contract_data/contract_types", to: "contract_data#contract_types"
      get "/contract_data/contract_statuses", to: "contract_data#contract_statuses"
      get "/contract_data/contract_name_customeres", to: "contract_data#contract_name_customeres"
      get "/contract_data/contract_vehicles", to: "contract_data#contract_vehicles"
      get "/contract_data/contract_vehicle_number", to: "contract_data#contract_vehicle_number"
      get "/contract_data/contract_number", to: "contract_data#contract_number"
      get "/contract_data/subcontract_number", to: "contract_data#subcontract_number"
      get "/contract_data/contract_prime", to: "contract_data#contract_prime"
      get "/contract_data/contract_current_pop", to: "contract_data#contract_current_pop"
      get "/contract_data/contract_classification", to: "contract_data#contract_classification"
      
      # Portfolio View
      get "/portfolio/programs", to: "portfolio#programs"
      get "/portfolio/lessons", to: "portfolio#lessons"
      get "/portfolio/tasks", to: "portfolio#tasks"
      get "/portfolio/risks", to: "portfolio#risks"
      get "/portfolio/issues", to: "portfolio#issues"
      get "/portfolio/tab_counts", to: "portfolio#tab_counts"
      # get "/projects/:id", to: "projects#show"

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

  ## New Routes for Vue

  # get "/programs/:id/"  => "projects#show"
  # get "/programs/:program_id/dataviewer" => "projects#program_dataviewer"
  # get "/programs/:program_id/dataviewer/:project_id/task/:task_id" => "projects#program_dataviewer"
  # get "/programs/:program_id/dataviewer/:project_id/risk/:risk_id" => "projects#program_dataviewer"
  # get "/programs/:program_id/dataviewer/:project_id/issue/:issue_id" => "projects#program_dataviewer"
  # get "/programs/:program_id/dataviewer/:project_id/lesson/:lesson_id" => "projects#program_dataviewer"

  # get "/programs/:program_id/:tab" => "projects#vue_js_route"
  # get "/programs/:program_id/:tab/new" => "projects#vue_js_route"
  # get "/programs/:program_id/lessons/:lesson_id" => "projects#vue_js_route"
  # get "/programs/:program_id/:tab/projects/:project_id/" => "projects#vue_js_route"

  # get "/programs/:program_id/:tab/projects/:project_id/overview" => "projects#vue_js_route"

  # get "/programs/:program_id/:tab/projects/:project_id/tasks" => "projects#vue_js_route"
  # get "/programs/:program_id/:tab/projects/:project_id/tasks/:id" => "projects#vue_js_route"

  # get "/programs/:program_id/:tab/projects/:project_id/issues" => "projects#vue_js_route"
  # get "/programs/:program_id/:tab/projects/:project_id/issues/:id" => "projects#vue_js_route"

  # get "/programs/:program_id/:tab/projects/:project_id/risks" => "projects#vue_js_route"
  # get "/programs/:program_id/:tab/projects/:project_id/risks/:id" => "projects#vue_js_route"

  # get "/programs/:program_id/:tab/projects/:project_id/notes" => "projects#vue_js_route"
  # get "/programs/:program_id/:tab/projects/:project_id/notes/:id" => "projects#vue_js_route"

  # get "/programs/:program_id/:tab/projects/:project_id/lessons" => "projects#vue_js_route"
  # get "/programs/:program_id/:tab/projects/:project_id/lessons/:id" => "projects#vue_js_route"

  # TODO: Comment this API and Uncomment the one in namespace once front end is working with JWT 
  # get "/api/v1/programs/:program_id/lessons" => "lessons#index"
  # get "/api/v1/programs/:program_id/projects/:project_id/lessons" => "lessons#index"
  # get "/api/v1/programs/:program_id/projects/:project_id/lessons/count" => "lessons#count"
  # get "/api/v1/programs/:program_id/lessons/count" => "lessons#count"
  # get "/api/v1/programs/:program_id/projects/:project_id/lessons/:lesson_id" => "lessons#show"

  # post "/api/v1/programs/:program_id/projects/:project_id/lessons" => "lessons#create"
  # patch "/api/v1/programs/:program_id/projects/:project_id/lessons/:lesson_id" => "lessons#update"
  # delete "/api/v1/programs/:program_id/projects/:project_id/lessons/:lesson_id" => "lessons#destroy"

  # resources :projects, only: [:index, :show] do
  #   get :gantt_chart, on: :member
  #   ##  get :watch_view, on: :member
  #   get :sheet, on: :member
  #   get :member_list, on: :member
  #   ##  get :facility_manager, on: :member
  #   get :kanban, on: :member
  #   get :map, on: :member    
  #   get :calendar, on: :member

  #   resources :lessons

  #   resources :query_filters do
  #     collection do
  #       delete "reset" => "query_filters#reset"
  #     end
  #   end

  #   resources :facilities do
  #     resources :notes #, module: :facilities
  #     resources :issues do
  #       post :batch_update, on: :collection
  #       post :create_duplicate, on: :member
  #       post :create_bulk_duplicate, on: :member
  #     end
  #     resources :risks do
  #       post :batch_update, on: :collection
  #       post :create_duplicate, on: :member
  #       post :create_bulk_duplicate, on: :member
  #     end
  #     resources :tasks do
  #       post :batch_update, on: :collection
  #       post :create_duplicate, on: :member
  #       post :create_bulk_duplicate, on: :member
  #     end
  #   end
  # end
  # resources :facilities, only: [] do
  #   resources :facility_projects, only: [:index, :update, :show]
  # end
  # resources :facility_projects, only: [:index, :update, :show] do
  #   resources :issues do
  #     post :batch_update, on: :collection
  #     post :create_duplicate, on: :member
  #     post :create_bulk_duplicate, on: :member
  #   end
  #   resources :risks do
  #     post :batch_update, on: :collection
  #     post :create_duplicate, on: :member
  #     post :create_bulk_duplicate, on: :member
  #   end
  #   resources :tasks do
  #     post :batch_update, on: :collection
  #     post :create_duplicate, on: :member
  #     post :create_bulk_duplicate, on: :member
  #   end
  # end

  # resources :dashboard, only: [:index]

  # get '/profile', to: 'profiles#index'
  # post '/profile', to: 'home#update'
  # get '/current_user', to: 'profiles#current_profile'

  #TODO: remove if no error found
  # get '/settings', to: 'data#settings'
  # get '/facility_groups', to: 'data#facility_groups'
  # get '/task_types', to: 'data#task_types'
  # get '/statuses', to: 'data#statuses'

  # get "/portfolio" => "home#portfolio"
  get '/profile' => 'home#profile'

  root 'home#landing'
  mount ActiveStorage::Engine, at: '/rails/active_storage'

  # Strictly matching programs/<program_id>/dataviewer
  get '*all', to: "home#contract", constraints: -> (req) do
    # (p = req.path.split("/")[1] ) && p.split("portfolio").size == 1 && p.split("portfolio").include?("portfolio")
    spath = req.path.split("/")
    i = spath.index("contract")
    # TODO: create regex for pattern programs/<program_id>/dataviewer
    i && (p = spath[i] ) && p.match(/^[contract]+$/)
  end

  # Strictly matching programs/<program_id>/dataviewer
  get '*all', to: "home#settings", constraints: -> (req) do
    # (p = req.path.split("/")[1] ) && p.split("portfolio").size == 1 && p.split("portfolio").include?("portfolio")
    spath = req.path.split("/")
    i = spath.index("settings")
    # TODO: create regex for pattern programs/<program_id>/dataviewer
    i && (p = spath[i] ) && p.match(/^[settings]+$/)
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
    (p = req.path.split("/")[1] ) && p.match(/^[portoflio]+$/)
  end

  get "*path", to: 'home#index', constraints: -> (req) do
    !req.xhr? && req.format.html?
  end
  
  get '*all', to: "not_found#index", constraints: -> (req) do
    req.path.exclude? 'rails/active_storage'
  end
end