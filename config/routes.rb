Rails.application.routes.draw do
  get 'static_pages/home' => 'static_pages#home'
  get 'static_pages/help' =>'static_pages#help'
  get 'static_pages/about' => 'static_pages#about'
  resources :microposts
  resources :users
  root to: "users#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
