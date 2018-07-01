Rails.application.routes.draw do
  resources :users
  root "pages#home"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/signup", to: "users#new"
  resources :companies, except: [:edit, :update] do
    resources :categories, except: [:edit, :update]
  end
  resources :posts
  resources :icons, only: [:new, :create, :destroy]
  post "/add_user", to: "companies#add_user"
  delete "/add_user", to: "companies#remove_user"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
