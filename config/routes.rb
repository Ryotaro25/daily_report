Rails.application.routes.draw do
  root 'static_pages#home'
  get '/help', to: 'static_pages#home'
  get '/members', to: 'static_pages#members'
  get '/account', to:'static_pages#account'
end
