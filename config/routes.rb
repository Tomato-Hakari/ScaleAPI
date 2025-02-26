Rails.application.routes.draw do
  resources :scale_data
  post '/index', to: 'dbupdates#index'

  # ルートパスを設定（例: ScaleDataController の index をトップページにする）
  root 'scale_data#index'
end
