Rails.application.routes.draw do

  resources :elo_users
  resources :user_informations

  root 'elo_users#index'

end
