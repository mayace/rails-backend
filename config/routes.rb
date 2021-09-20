Rails.application.routes.draw do
  resources :users
  get "auth/login", to: "auth#hola"
  post "auth/login", to: "auth#login"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
