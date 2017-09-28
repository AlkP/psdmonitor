Rails.application.routes.draw do
  root 'home#index'

  get '/actions', to: 'home#history', as: 'user_history'
  get '/status_report', to: 'home#status_report', as: 'report'

  post 'home/show_history'
end
