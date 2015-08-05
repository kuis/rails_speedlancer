Rails.application.routes.draw do

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  match "/delayed_job" => DelayedJobWeb, :anchor => false, via: [:get, :post]

  devise_for :sellers, :controllers => { :sessions => "sellers/sessions", :registrations => "sellers/registrations" }, :skip => [:confirmations], :path_names => { :sign_in => "login"}
  devise_scope :seller do
    get "/sign_in_as_seller" => "sellers/sessions#sign_in_as_seller"
  end

  resources :support_tickets, only: [:new, :create]

  resources :sellers, only: [] do
    get 'profile', on: :member
    get 'active_tasks'
    get 'completed_tasks'
    get 'tasks_feedbacks'
  end

  resources :buyers, only: [] do
    get 'profile', on: :member
    get 'active_tasks'
    get 'completed_tasks'
    get 'in_progress_tasks'
    get 'lapsed_tasks'
    get 'add_credits', on: :collection
  end

  resources :category, only: [:index, :show]

  resources :tasks do
    get 'accept_task', on: :member 
    get 'test_notify'
    put :add_watcher, on: :member
    put :remove_watcher, on: :member

    resources :task_attachments do
      get 'download_file', on: :member
    end
    resources :comments
    resources :feedbacks
    resources :messages
    resources :sellers_submissions do
      get 'approve', on: :member
      get 'revise', on: :member
    end
  end

  resources :sellers_submissions, only: [] do
    resources :submission_attachments, only: [] do
      get 'download_file', on: :member
    end
  end

  devise_for :buyers, :controllers => { :sessions => "buyers/sessions", :registrations => "buyers/registrations", :passwords => "buyers/passwords" }, :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "signup" }

  devise_scope :buyer do
    get '/login' => 'devise/sessions#new'
    get '/signup' => 'buyers/registrations#new'
    get "/sign_in_as_buyer" => "buyers/sessions#sign_in_as_buyer"
    get "/new_password" => "buyers/passwords#new"
  end

  post 'tasks/:id' => 'tasks#show'
  post '/hook', controller: 'payment_notifications', action: :hook

  post 'buyers/:id/active_tasks' => 'buyers#active_tasks'
  post '/credit_hook', controller: 'payment_notifications', action: :credit_hook

  get '/reset_bots', controller: 'buyers', action: :reset_bots

  get '/tasks_log', controller: 'tasks', action: :tasks_log

  root to: "tasks#index"

  # Api with Wordpress app
  namespace :api do
    namespace :v1 do
      resources :tasks, only: [:create]
      resources :shopify, only: [:create]
    end
  end


end

