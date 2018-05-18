Rails.application.routes.draw do

  post '/users(.:format)', to: 'users#create'
  devise_for :users
  resources :users do
    resources :accesses
  end
  resources :elo_users
  resources :user_informations
  resources :elo_usr_errs

  get '/f440', to: 'regulations#f440', as: 'f440'
  get '/f311', to: 'regulations#f311', as: 'f311'

  root 'regulations#dashboards'
end
