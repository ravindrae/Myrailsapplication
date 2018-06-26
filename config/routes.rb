Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
  get '/signup',to:'users#new'
  root to: "static_pages#home"

  resources :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
