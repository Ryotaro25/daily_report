Rails.application.routes.draw do
  get 'likes/create'
  get 'likes/destroy'
  root 'static_pages#home'
  get '/help', to: 'static_pages#home'
  get '/account', to:'static_pages#account'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy, :show, :edit, :update] do
    resources :comments, only: [:create, :destroy]
  end
  resources :likes, only: [:create, :destroy]
end

