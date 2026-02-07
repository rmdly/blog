Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  root "posts#index"

  resources :posts do
    resources :comments, only: %i[create destroy]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
