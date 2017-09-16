Rails.application.routes.draw do

  resources :elo_users
  resources :user_informations
  resources :elo_usr_errs

  root 'elo_usr_errs#index'

end
