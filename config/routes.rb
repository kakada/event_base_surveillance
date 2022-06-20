# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-scheduler/web"
require_relative "whitelist"

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "events#index"
  devise_for :users, path: "/", controllers: { confirmations: "confirmations", omniauth_callbacks: "users/omniauth_callbacks" }

  # https://github.com/plataformatec/devise/wiki/How-To:-Override-confirmations-so-users-can-pick-their-own-passwords-as-part-of-confirmation-activation
  as :user do
    match "/confirmation" => "confirmations#update", :via => :put, :as => :update_user_confirmation
  end

  resources :programs do
    get :es_reindex, on: :member
    resource :telegram_bot
  end

  get "helps/how-to-connect-telegram-bot", to: "helps#telegram_bot"
  get "helps/how-to-connect-telegram-account", to: "helps#telegram_account"

  scope module: :programs do
    resource :setting, only: [:show, :update]
  end

  resources :users

  resource :locale, only: [:update]

  resources :events do
    scope module: :events do
      resources :event_milestones
      resource :preview, only: [:show]
      resources :follow_ups, only: [:new, :create]
    end

    get :download, on: :collection
    get :search, on: :collection
    put :unlock, on: :member
  end

  resources :schedules do
    get :activate, on: :member
    get :deactivate, on: :member
  end

  resources :medisys_feeds, only: :index
  resources :medisies do
    get :help, on: :collection
  end

  resources :event_types do
    get :shared, on: :member
    get :unshared, on: :member
  end

  resources :milestones do
    scope module: :milestones do
      resource :message
    end

    put :reorder, on: :collection
  end

  resources :client_apps do
    get :activate, on: :member
    get :deactivate, on: :member
    get :info, on: :collection
  end

  resources :webhooks, except: [:show] do
    get :activate, on: :member
    get :deactivate, on: :member
  end

  resource :download, only: [:show]
  resources :about_us, only: [:index]
  resources :locations, only: [:index]

  resources :maps

  resources :templates

  # API
  namespace :api do
    namespace :v1 do
      resources :milestones do
        resources :fields, only: [:index], module: "milestone"
      end
      resources :event_types, only: [:index]
      resources :events, except: [:new, :edit, :destroy]
      resources :event_milestones, only: [:create, :update]
    end
  end

  # Pumi
  mount Pumi::Engine => "/pumi"

  constraints Whitelist do
    # Telegram
    telegram_webhook TelegramWebhooksController
  end

  if Rails.env.production?
    # Sidekiq
    authenticate :user, lambda { |u| u.system_admin? } do
      mount Sidekiq::Web => "/sidekiq"
    end

    # Dashboard
    authenticate :user, lambda { |u| u.system_admin? || u.program_admin? } do
      resource :dashboard, only: :show
    end
  else
    mount Sidekiq::Web => "/sidekiq"
    resource :dashboard, only: :show
  end
end
