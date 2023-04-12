Rails.application.routes.draw do

  root "leads#new"

  resources :leads, only: [:new, :create, :show]
end
