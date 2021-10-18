Rails.application.routes.draw do
  resources :scale_data
  post '/index', to: 'dbupdates#index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
