# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :admins

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root 'books#index'

  resources :books
  resources :authors, except: :show

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :books, only: %i[index show]
    end
  end

  namespace :admin, module: 'admin_panel' do
    get '/' => 'dashboard#index'
    resources :admins
    resources :imports, only: %i[index show new create]
  end
end
