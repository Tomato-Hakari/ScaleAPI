Rails.application.routes.draw do
  root 'scale_data#index'  # ここを追加
  resources :scale_data
  post '/index', to: 'dbupdates#index'
end
