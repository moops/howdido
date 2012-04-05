Howdido::Application.routes.draw do
  root :to => "races#index"
  get 'signup', to: 'users#new', as: 'signup'
  get 'login', to: 'user_sessions#new', as: 'login'
  get 'logout', to: 'user_sessions#destroy', as: 'logout'
  resources :participations
  resources :user_sessions
  resources :results
  resources :races
  resources :users
  match 'races/:id/load' => 'results#load', :as => :load_results
end
