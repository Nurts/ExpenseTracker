Rails.application.routes.draw do
  resources :users
  get 'auth/:provider/callback', to: 'sessions#omniauth_create'
  get 'auth/failure', to: redirect('/')
  root "pages#home"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "/signup", to: "users#new"
  resources :companies, except: [:edit, :update] do
    resources :categories, except: [:edit, :update]
  end
  get "/companies/:id/record", to: "companies#record", as: 'record'
  resources :posts, except: [:show, :index]
  resources :icons, only: [:new, :create, :destroy]
  post "/add_user", to: "companies#add_user"
  delete "/add_user", to: "companies#remove_user"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
