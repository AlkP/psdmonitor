Rails.application.routes.draw do

  devise_for :users
  resources :elo_users
  resources :user_informations
  resources :elo_usr_errs

  root 'regulations#dashboards'

end
