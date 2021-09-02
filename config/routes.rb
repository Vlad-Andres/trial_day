Rails.application.routes.draw do
  get 'sessions/new'
  resources :users
  resources :todos
  root 'todos#index'
  get '/todo/calendar/:id', to: 'todos#calendar', as: 'calendar'
  get '/search', to: 'todos#index', as: 'search'
  get '/filter', to: 'todos#index', as: 'filter'

  get '/login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#delete'
end
