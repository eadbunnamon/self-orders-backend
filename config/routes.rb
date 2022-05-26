Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :v1, defaults: { format: :json } do
    post 'login' => 'authentication#authenticate_user'

    resources :restaurant_types
    resources :restaurants do
      resources :tables
      resources :categories
    end
  end
end
