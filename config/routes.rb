Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', to: 'static_pages#home'
  get '/account', to:'static_pages#account'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get 'group/new'
  get 'likes/create'
  get 'likes/destroy'
  resources :users
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy, :show, :edit, :update] do
    resources :comments, only: [:create, :destroy]
  end
  resources :likes, only: [:create, :destroy]
  resources :groups, only: [:new, :create, :edit, :destroy, :update, :index] do
    member do
      get :join, :leave
    end
  end
  resources :guest_sessions, only: [:create]
end

