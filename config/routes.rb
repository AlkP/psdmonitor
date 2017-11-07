Rails.application.routes.draw do
  root 'home#index'

  get '/actions', to: 'home#history', as: 'user_history'
  get '/status_report', to: 'home#status_report', as: 'report'
  get '/print', to: 'home#print', as: 'print'
  get '/show_file/:id', to: 'home#show_file', as: 'show_file'
  get '/show_error/:file_name', to: 'home#show_error', as: 'show_error'

  post 'home/show_history'
end
