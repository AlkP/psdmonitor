Rails.application.routes.draw do
  root 'home#index'

  get '/actions', to: 'home#history', as: 'user_history'

  post 'home/show_history'
end
