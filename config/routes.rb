Rails.application.routes.draw do
  root "tasks#index"

  resources :tasks, only: [:index, :create, :edit, :update, :destroy]

  get "/search", to: "tasks#search"
  post "/history/unlock", to: "tasks#unlock_history"

  get "up" => "rails/health#show", as: :rails_health_check
end