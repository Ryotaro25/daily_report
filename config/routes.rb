Rails.application.routes.draw do
  get 'session/new'
  root 'static_pages#home'
  get '/help', to: 'static_pages#home'
  get '/members', to: 'static_pages#members'
  get '/account', to:'static_pages#account'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  resources :users
end
