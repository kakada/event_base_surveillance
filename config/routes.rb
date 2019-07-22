require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "home#index"
  devise_for :users, path: '/', :controllers => { :confirmations => "confirmations" }

  as :user do
    match '/confirmation' => 'confirmations#update', :via => :put, :as => :update_user_confirmation
  end

  resources :users
  resources :events
  resources :event_types do
    scope module: :event_types do
      resources :form_types
    end
  end

  mount Sidekiq::Web => '/sidekiq'
end
