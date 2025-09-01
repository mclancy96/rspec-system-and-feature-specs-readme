
Rails.application.routes.draw do
  root "workouts#index"

  # Top-level resources for full RESTful routes and helpers
  resources :workouts
  resources :exercises

  resources :users do
    resources :workouts, shallow: true do
      resources :exercises, shallow: true
    end
  end

  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  get "up" => "rails/health#show", as: :rails_health_check
end
