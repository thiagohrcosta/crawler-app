Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  root "leads#new"

  resources :leads, only: [:new, :create, :show]
  resources :dashboards, only: [:index]
end
