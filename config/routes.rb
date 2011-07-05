Howdido::Application.routes.draw do
  resources :participations

  resources :user_sessions

  resources :lookups

  resources :results

  resources :races
  match 'races/:id/load' => 'results#load', :as => :load_results

  resources :users
  
  match 'login' => 'login#index', :as => :login
  
  root :to => "races#index"
end
