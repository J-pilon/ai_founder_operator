Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Health check endpoint
  get "health", to: "health#show"

  # Defines the root path route ("/")
  # root "articles#index"
end
