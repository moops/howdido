Howdido::Application.routes.draw do
  root :to => "races#index"
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'sessions#new', as: 'login'
  get 'logout', to: 'sessions#destroy', as: 'logout'
  resources :participations
  resources :sessions
  resources :results
  resources :races
  resources :users
  match 'races/:id/load' => 'results#load', :as => :load_results
end
