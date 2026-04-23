Rails.application.routes.draw do
  devise_for :users, path: "auth", path_names: { sign_in: "login", sign_up: "register" }
  root "posts#index"
  resources :posts do
    member do
      patch :publish
    end
    resources :likes, only: [ :create, :destroy ]
    resources :comments, only: [ :create, :destroy ]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  get "contact", to: "contact#new", as: :contact
  post "contact", to: "contact#create"

  get "about", to: "about#index", as: :about


  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show"
  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
end
