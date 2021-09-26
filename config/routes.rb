Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      get "auth/login", to: "auth#hola"
      post "auth/signup", to: "auth#cognito_signup"
      post "auth/confirm", to: "auth#cognito_confirm"
      post "auth/signin", to: "auth#cognito_signin"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
