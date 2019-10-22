require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'
  devise_for :users, path: '/', :controllers => { :confirmations => 'confirmations' }

  # https://github.com/plataformatec/devise/wiki/How-To:-Override-confirmations-so-users-can-pick-their-own-passwords-as-part-of-confirmation-activation
  as :user do
    match '/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end

  resources :programs

  scope module: :programs do
    resource :setting, only: [:show, :update]
  end

  resources :users
  resources :events do
    scope module: :events do
      resources :event_milestones
    end

    get :download, on: :collection
  end

  resources :event_types do
    get :shared, on: :member
    get :unshared, on: :member
  end

  resources :milestones do
    scope module: :milestones do
      resource :telegram
    end
  end

  resources :client_apps do
    get :activate, on: :member
    get :deactivate, on: :member
  end

  resources :webhooks, except: [:show] do
    get :activate, on: :member
    get :deactivate, on: :member
  end

  # API
  namespace :api do
    namespace :v1 do
      resources :event_types, only: [:index]
      resources :events, except: [:new, :edit]
    end
  end

  # Pumi
  mount Pumi::Engine => '/pumi'

  # Telegram
  telegram_webhook TelegramWebhooksController

  # Sidekiq
  if Rails.env.production?
    authenticate :user, lambda { |u| u.system_admin? } do
      mount Sidekiq::Web => '/sidekiq'
    end
  else
    mount Sidekiq::Web => '/sidekiq'
  end
end
