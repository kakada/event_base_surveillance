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
  resources :users
  resources :events do
    scope module: :events do
      resources :forms
    end
  end

  resources :event_types do
    scope module: :event_types do
      resources :form_types
    end

    get 'clone', on: :member
  end

  mount Pumi::Engine => '/pumi'
  mount Sidekiq::Web => '/sidekiq'
end
