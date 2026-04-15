Rails.application.routes.draw do
  
  devise_for :users, skip: [:registrations]

  root "pages#home"

  resources :posts do
    post "like", on: :member
  end
end
