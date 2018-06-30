Rails.application.routes.draw do
  resources :users
  root "pages#home"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/signup", to: "users#new"
  resources :companies
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
